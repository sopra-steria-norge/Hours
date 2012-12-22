//
//  DataFactory.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "DataFactory.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>

@interface DataFactory() <RKObjectLoaderDelegate>
@property (nonatomic, strong) RKObjectMapping *mapping;
@property (nonatomic, weak) id<AppStateReceiver> appStateReceiver;
@property (nonatomic, weak) id<LoginStateReceiver> loginStateReceiver;
@property (nonatomic, weak) id<AppStateSaver> appStateSaver;
@end

@implementation DataFactory

NSString * const URL = @"http://fakeswhrs.azurewebsites.net/"; // TODO: Load from .plist
NSString * const authenticationPath = @"/CheckAuthentication";
NSString * const authenticationTokenFormat = @"{\"username\":\"%@\", \"password\":\"%@\"}";
NSString * const authenticationHeaderKey = @"X-Authentication-Token";
NSString * const dateFormat = @"yyyy-MM-dd";

NSString * const hoursPath = @"/hours/week";
const double timeoutInterval = 30.0;

NSString * const postRegistrationPath = @"/hours/registration";
NSString * const updateRegistrationPath = @"/hours/updateRegistration";
NSString * const deleteRegistrationPath = @"/hours/deleteRegistration";
NSString * const submitPeriodPath = @"/hours/submitPeriod";
NSString * const reopenPeriodPath = @"/hours/reopenPeriod";


@synthesize appStateReceiver = _appStateReceiver;
@synthesize loginStateReceiver = _loginStateReceiver;
@synthesize appStateSaver = _appStateSaver;
@synthesize mapping = _mapping;

static AppState *_sharedAppState = nil;
static LoginState *_sharedLoginState = nil;

- (id) init
{
    self = [super init];
    if(self)
    {
        self.mapping = [self setupMapping];
    }
#ifdef debug
    RKLogConfigureByName("RestKit", RKLogLevelInfo);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelInfo);
    RKLogConfigureByName("RestKit/Network", RKLogLevelInfo);
#endif
    return self;
}

-(void)startCheckAuthenticationForLoginState:(LoginState *)loginState andDelegateReceiver:(id<LoginStateReceiver>) receiver
{
    self.loginStateReceiver = receiver;

    [self resetRestKitClient];

    NSURL *url = [self getBaseURL];
    RKClient *client = [RKClient clientWithBaseURL:url];
    client.timeoutInterval = timeoutInterval;
    [self setAuthenticationHeaderForClient:client user:loginState.userName saltedPassword:loginState.passwordHash];
    
    RKRequest *request = [client get:authenticationPath delegate:self];
    request.userData = loginState;
}

- (void)setAuthenticationHeaderForClient:(RKClient *)client user:(NSString *)user saltedPassword:(NSString *)saltedPassword {
    NSString *authenticationHeaderValue = [NSString stringWithFormat:authenticationTokenFormat, user, saltedPassword];
    [[client HTTPHeaders] setValue:authenticationHeaderValue forKey:authenticationHeaderKey];
}

-(void)startSavingRegistration:(Registration *)registration forDate:(NSDate *) date forDelegate:(id<AppStateSaver>) saver
{
    self.appStateSaver = saver;
    
    [self resetRestKitClient];
    
    NSURL *url = [self getBaseURL];
    RKClient *client = [RKClient clientWithBaseURL:url];
    client.timeoutInterval = timeoutInterval;
    
    NSDictionary *params = [self createParamsFromRegistration:registration forDate:date];
    
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
    NSError *error = nil;
    NSString *jsonParams = [parser stringFromObject:params error:&error];
    
    RKRequest *request = [client post:postRegistrationPath params:[RKRequestSerialization serializationWithData:[jsonParams dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON] delegate:self];
    request.userData = registration;
}

-(NSDictionary *)createParamsFromRegistration:(Registration *)registration forDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    
    NSString *dateString = [formatter stringFromDate:date];
    NSString *hours = [NSString stringWithFormat:@"%.1f", registration.hours];
    
    NSDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                            dateString, @"date",
                            hours, @"hours",
                            registration.description, @"description",
                            registration.activityCode, @"activityCode",
                            registration.projectNumber, @"projectNumber",
                            nil];
    
    return params;
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    if ([request isGET] && [request.userData isKindOfClass:[LoginState class]])
    {
        if ([response isOK])
        {
            _sharedLoginState = (LoginState *)request.userData;
            if(self.loginStateReceiver)
            {
                [self.loginStateReceiver didReceiveLoginState:_sharedLoginState];
            }
        }
        else
        {
            if(self.loginStateReceiver)
            {
                _sharedLoginState = nil;
                [self.loginStateReceiver didFailLoggingInWithError:[response failureError]];
            }
        }
    }
    else if ([request isPOST] && [request.userData isKindOfClass:[Registration class]])
    {
        if([response isOK])
        {
            if(self.appStateSaver)
            {
                Registration *r = (Registration *)request.userData;
                    
                [self.appStateSaver didSaveRegistration:r];
            }
        }
        else
        {
            if(self.appStateSaver)
            {
                [self.appStateSaver didFailSavingRegistrationWithError:[response failureError]];
            }
        }
    }
}

-(void) startGetDataForDate:(NSDate *)date andDelegateReceiver:(id<AppStateReceiver>) receiver
{
    self.appStateReceiver = receiver;

    [self resetRestKitClient];

    NSDictionary *additionalHeaders = nil;
    
    if(_sharedLoginState)
    {
        NSString *authenticationHeaderValue = [NSString stringWithFormat:authenticationTokenFormat, _sharedLoginState.userName, _sharedLoginState.passwordHash];
        additionalHeaders = [NSMutableDictionary dictionaryWithObject:authenticationHeaderValue forKey:authenticationHeaderKey];
    }
       
    NSURL *url = [self getBaseURL];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:url];
    manager.client.timeoutInterval = timeoutInterval;
    [manager loadObjectsAtResourcePath:hoursPath usingBlock:^(RKObjectLoader* loader)
     {
         loader.ObjectMapping = self.mapping;
         loader.delegate = self;
         loader.params = [[NSDictionary alloc] initWithObjectsAndKeys:@"date@", date, nil];
         loader.additionalHTTPHeaders = additionalHeaders;
     } ];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    RKLogInfo(@"Load collection of Projects: %@", objects);
        
    AppState *state = [[AppState alloc] init];
    NSDictionary *params = (NSDictionary *)objectLoader.params;
    state.currentDate = [params objectForKey:@"date"];
    
    if(objects.count > 0 && [[objects objectAtIndex:0] isKindOfClass:[Week class]])
    {
        // TODO: Add week to weeks dictionary to cache data between weeks

        Week *week = [objects objectAtIndex:0];
        week.downloadTimestamp = [[NSDate alloc] init];
        week.isApproved = [DataFactory getApprovedStatusForWeek:week];
        week.isSubmitted = [DataFactory getSubmittedStatusForWeek:week];
        
        state.currentWeek = week;
    }
    
    _sharedAppState = state;
    
    if(self.appStateReceiver)
    {
        [self.appStateReceiver didReceiveAppState:state];
    }
    
    objectLoader.delegate = nil; // Without this RestKit will attempt some rather nasty callbacks that are not available
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"ObjectLoader failed with error: %@", error);
    if(self.appStateReceiver)
    {
        [self.appStateReceiver didFailLoadingAppStateWithError:error];
    }
}

- (RKObjectMapping *)setupMapping
{
    RKObjectMapping *projectMapping = [RKObjectMapping mappingForClass:[Project class]];
    projectMapping.forceCollectionMapping = YES;
    [projectMapping mapKeyOfNestedDictionaryToAttribute:@"projectCode"];
    [projectMapping mapKeyPath:@"(projectCode).description" toAttribute:@"description"];
    [projectMapping mapKeyPath:@"(projectCode).activityCode" toAttribute:@"activityCode"];
    [projectMapping mapKeyPath:@"(projectCode).projectName" toAttribute:@"projectName"];
    [projectMapping mapKeyPath:@"(projectCode).projectNumber" toAttribute:@"projectNumber"];
    
    RKObjectMapping *registrationMapping = [RKObjectMapping mappingForClass:[Registration class]];
    registrationMapping.forceCollectionMapping = YES;
    [registrationMapping mapKeyOfNestedDictionaryToAttribute:@"registrationNumber"];
    [registrationMapping mapKeyPath:@"(registrationNumber).activityCode" toAttribute:@"activityCode"];
    [registrationMapping mapKeyPath:@"(registrationNumber).approved" toAttribute:@"approved"];
    [registrationMapping mapKeyPath:@"(registrationNumber).hours" toAttribute:@"hours"];
    [registrationMapping mapKeyPath:@"(registrationNumber).description" toAttribute:@"description"];
    [registrationMapping mapKeyPath:@"(registrationNumber).rejected" toAttribute:@"rejected"];
    [registrationMapping mapKeyPath:@"(registrationNumber).submitted" toAttribute:@"submitted"];
    [registrationMapping mapKeyPath:@"(registrationNumber).workType" toAttribute:@"workType"];
    [registrationMapping mapKeyPath:@"(registrationNumber).projectNumber" toAttribute:@"projectNumber"];
    
    RKObjectMapping *dayMapping = [RKObjectMapping mappingForClass:[Day class]];
    dayMapping.forceCollectionMapping = YES;
    [dayMapping mapKeyOfNestedDictionaryToAttribute:@"date"];
    [dayMapping mapKeyPath:@"(date)" toRelationship:@"registrations" withMapping:registrationMapping];
    
    RKObjectMapping *weekMapping = [RKObjectMapping mappingForClass:[Week class]];
    [weekMapping mapKeyPath:@"periodDescription" toAttribute:@"description"];
    [weekMapping mapKeyPath:@"periodNormTime" toAttribute:@"normTime"];
    [weekMapping mapKeyPath:@"projects" toRelationship:@"projects" withMapping:projectMapping];
    [weekMapping mapKeyPath:@"days" toRelationship:@"days" withMapping:dayMapping];
    return weekMapping;
}

- (NSURL *)getBaseURL {
    NSURL *url = [NSURL URLWithString:URL];
    return url;
}

- (void)resetRestKitClient {
    [RKClient setSharedClient:nil];
    [RKObjectManager setSharedManager:nil];
}

+(bool) getApprovedStatusForWeek:(Week *)week
{
    for(Day *day in week.days)
    {
        for(Registration *r in day.registrations)
        {
            if(r.approved)
            {
                return true;
            }
        }
    }
    return false;
}

+(bool) getSubmittedStatusForWeek:(Week *)week
{
    for(Day *day in week.days)
    {
        for(Registration *r in day.registrations)
        {
            if(r.submitted)
            {
                return true;
            }
        }
    }
    return false;
}

+ (AppState*)sharedAppState
{
    return _sharedAppState;
}

+ (LoginState*)sharedLoginState
{
    return _sharedLoginState;
}

+ (void)clearState
{
    _sharedAppState = nil;
    _sharedLoginState = nil;
}

@end
