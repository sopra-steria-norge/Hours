//
//  DataFactory.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "DataFactory.h"
#import <RestKit/RestKit.h>

@interface DataFactory() <RKRequestDelegate, RKObjectLoaderDelegate>
@end

@implementation DataFactory

@synthesize receiver = _receiver;

-(void) startGetDataForDate:(NSDate *)date andDelegateReceiver:(id<AppStateReceiver>) receiver
{
    self.receiver = receiver;
    [self loadProjects];
}

- (void)loadProjects {
    RKObjectManager *manager = [RKObjectManager managerWithBaseURLString:@"http://fakeswhrs.azurewebsites.net"];
    [self setupProjectMappingForManager:manager];
    [self setupWeekMappingForManager:manager];
    
    [manager loadObjectsAtResourcePath:@"/week/hours" delegate:self];
}

- (void)setupProjectMappingForManager:(RKObjectManager *)manager
{
    RKObjectMapping *projectMapping = [RKObjectMapping mappingForClass:[Project class]];
    projectMapping.forceCollectionMapping = YES;
    [projectMapping mapKeyOfNestedDictionaryToAttribute:@"projectCode"];
    [projectMapping mapKeyPath:@"(projectCode).description" toAttribute:@"description"];
    [projectMapping mapKeyPath:@"(projectCode).activityCode" toAttribute:@"activityCode"];
    [projectMapping mapKeyPath:@"(projectCode).projectName" toAttribute:@"projectName"];
    [projectMapping mapKeyPath:@"(projectCode).projectNumber" toAttribute:@"projectNumber"];

    [manager.mappingProvider setMapping:projectMapping forKeyPath:@"projects"];
}

- (void)setupWeekMappingForManager:(RKObjectManager *)manager
{
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
    
    [manager.mappingProvider setMapping:dayMapping forKeyPath:@"days"];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    RKLogInfo(@"Load collection of Projects: %@", objects);
    
    NSMutableArray *days = [[NSMutableArray alloc] init];
    NSMutableArray *projects = [[NSMutableArray alloc] init];
    
    for(id object in objects)
    {
        if([object isKindOfClass:[Day class]])
        {
            [days addObject:object];
        }
        else if([object isKindOfClass:[Project class]])
        {
            [projects addObject:object];
        }
    }
    
    AppState *state = [[AppState alloc] init];
    state.week = [[Week alloc] init];
    state.week.days = days;
    state.projects = projects;
    
    if(self.receiver)
    {
        [self.receiver didReceiveAppState:state];
    }
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"ObjectLoader failed with error: %@", error);
}

- (void)sendRequests
{

    // Perform a simple HTTP GET and call me back with the results
    [ [RKClient sharedClient] get:@"/hours/week" delegate:self];
}

@end
