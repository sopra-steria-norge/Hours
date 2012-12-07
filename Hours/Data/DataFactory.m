//
//  DataFactory.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "DataFactory.h"
#import <RestKit/RestKit.h>

@interface DataFactory() <RKObjectLoaderDelegate>
@property (nonatomic, strong) RKObjectMapping *mapping;
@property(nonatomic, weak) id<AppStateReceiver> appStateReceiver;
@property(nonatomic, weak) id<LoginStateReceiver> loginStateReceiver;

@end

@implementation DataFactory

NSString * const URL = @"http://fakeswhrs.azurewebsites.net/"; // TODO: Load from .plist
NSString * const authenticationPath = @"/CheckAuthentication";
NSString * const hoursPath = @"/week/hours";

@synthesize appStateReceiver = _appStateReceiver;
@synthesize loginStateReceiver = _loginStateReceiver;
@synthesize mapping = _mapping;

static AppState *_sharedState = nil;
static LoginState *_loginState = nil;

-(void) refreshDataForReceiver:(id<AppStateReceiver>) receiver
{
    // TODO: Implement
}

- (id) init
{
    self = [super init];
    if(self)
    {
        self.mapping = [self setupMapping];
    }
    
    return self;
}

-(void) startCheckAuthenticationForUser:(NSString *) user withPasswordToken:(NSString *)hashedAndSaltedPassword andDelegateReceiver:(id<LoginStateReceiver>) receiver
{
    self.loginStateReceiver = receiver;

    [self resetRestKitClient];

    NSURL *url = [self getBaseURL];
    RKClient *client = [RKClient clientWithBaseURL:url];
    
    NSString *authenticationHeaderValue = [NSString stringWithFormat:@"{\"username\":\"%@\", \"password\":\"%@\"}", user, hashedAndSaltedPassword];
    [[client HTTPHeaders] setValue:authenticationHeaderValue forKey:@"X-Authentication-Token"];
    
    [client get:authenticationPath delegate:self];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    if ([request isGET])
    {
        if ([response isOK])
        {
            LoginState *state = [[LoginState alloc]init];
            _loginState = state;

            if(self.loginStateReceiver)
            {
                [self.loginStateReceiver didReceiveLoginState:state];
            }
        }
        else
        {
            if(self.loginStateReceiver)
            {
                [self.loginStateReceiver didFailLoggingInWithError:[response failureError]];
            }
        }
    }
}

-(void) startGetDataForDate:(NSDate *)date andDelegateReceiver:(id<AppStateReceiver>) receiver
{
    self.appStateReceiver = receiver;

    [self resetRestKitClient];

    NSURL *url = [self getBaseURL];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:url];
    [manager loadObjectsAtResourcePath:hoursPath usingBlock:^(RKObjectLoader* loader)
     {
         loader.ObjectMapping = self.mapping;
         loader.delegate = self;
         loader.params = [[NSDictionary alloc] initWithObjectsAndKeys:@"date@", date, nil];
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
    
    _sharedState = state;
    
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


+ (AppState*)sharedState
{
    return _sharedState;
}

+ (void)clearState
{
    _sharedState = nil;
}

@end
