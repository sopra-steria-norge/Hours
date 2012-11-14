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
@end

@implementation DataFactory

@synthesize receiver = _receiver;
@synthesize mapping = _mapping;

- (id) init
{
    self = [super init];
    if(self)
    {
        self.mapping = [self setupMapping];
    }
    
    return self;
}

-(void) startGetDataFromUrl: (NSURL *) url forDate:(NSDate *)date andDelegateReceiver:(id<AppStateReceiver>) receiver
{
    self.receiver = receiver;

    // Clear singleton instances
    [RKClient setSharedClient:nil];
    [RKObjectManager setSharedManager:nil];

    RKObjectManager * manager = [RKObjectManager managerWithBaseURL:url];
    [manager loadObjectsAtResourcePath:@"/week/hours" usingBlock:^(RKObjectLoader* loader)
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
        state.week = [objects objectAtIndex:0];
    }
    
    if(self.receiver)
    {
        [self.receiver didReceiveAppState:state];
    }
    
    objectLoader.delegate = nil; // Without this RestKit will attempt some rather nasty callbacks that are not available
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"ObjectLoader failed with error: %@", error);
    if(self.receiver)
    {
        [self.receiver didFailLoadingAppStateWithError:error];
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

@end
