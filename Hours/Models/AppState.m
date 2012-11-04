//
//  AppState.m
//  iSwhrs-native
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "AppState.h"
#import "DataFactory.h"
#import <RestKit/RestKit.h>

@interface AppState() <RKRequestDelegate>

@property(nonatomic, readwrite, strong) NSDate *currentDate;
@property(nonatomic, readwrite, strong) Week *week;

@end

@implementation AppState

@synthesize currentDate = _currentDate;
@synthesize week = _week;


-(id) initWithDate:(NSDate *) date {
    self = [self init];
    if(self)
    {
        self.currentDate = date;
        Week *week = [[Week alloc] init]; // TODO Get data
        self.week = week;
        [self sendRequests];
    }
    return self;
}

- (void)sendRequests {
    // Perform a simple HTTP GET and call me back with the results
    [ [RKClient sharedClient] get:@"/hours/week" delegate:self];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK]) {
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
