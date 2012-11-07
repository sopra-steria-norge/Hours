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

-(void) startGetDataForDate:(NSDate *)date andDelegateReceiver:(id<WeekReceiver>) receiver
{
    self.receiver = receiver;
    [self loadProjects];
}

- (void)loadProjects {
    RKObjectManager *manager = [RKObjectManager managerWithBaseURLString:@"http://fakeswhrs.azurewebsites.net"];
    [self setupProjectMappingForManager:manager];

    [manager loadObjectsAtResourcePath:@"/week/hours" delegate:self];
}

- (void)setupProjectMappingForManager:(RKObjectManager *)manager {
    RKObjectMapping* projectMapping = [RKObjectMapping mappingForClass:[Project class]];
    projectMapping.forceCollectionMapping = YES;
    [projectMapping mapKeyOfNestedDictionaryToAttribute:@"projectCode"];
    [projectMapping mapKeyPath:@"(projectCode).description" toAttribute:@"description"];
    [projectMapping mapKeyPath:@"(projectCode).activityCode" toAttribute:@"activityCode"];
    [projectMapping mapKeyPath:@"(projectCode).projectName" toAttribute:@"projectName"];
    [projectMapping mapKeyPath:@"(projectCode).projectNumber" toAttribute:@"projectNumber"];

    [manager.mappingProvider setMapping:projectMapping forKeyPath:@"projects"];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    RKLogInfo(@"Load collection of Projects: %@", objects);
    
    for(Project *p in objects)
    {
        NSLog(@"\tProject number: %@", p.projectNumber);
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

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK])
        {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
    }
        
    } else if ([request isPOST]) {
        
        // Handling POST /other.json
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
        
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

@end
