//
//  DataFactory.m
//  iSwhrs-native
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "DataFactory.h"
#import <RestKit/RestKit.h>

@interface DataFactory() <RKRequestDelegate>
@end

@implementation DataFactory

@synthesize receiver = _receiver;

-(void) startGetDataForDate:(NSDate *)date andDelegateReceiver:(id<WeekReceiver>) receiver
{
    self.receiver = receiver;
    [self sendRequests];
}

-(Week *) createTestPeriod
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    Project *project1 = [[Project alloc] initWithprojectNumber:@"projNo" andActivityCode:@"actCode" andDescription:@"description"];
    Registration *reg1 = [[Registration alloc] initWithDate:[dateFormat dateFromString:@"2012-09-11"]
                                             andDescription:@"Reg. description" andHours:5.0 andProject:project1 andIsSubmitted:NO andIsApproved:NO];
    
    Project *project2 = [[Project alloc] initWithprojectNumber:@"LUNSJ" andActivityCode:@"LU" andDescription:@"Lunsj"];
    Registration *reg2 = [[Registration alloc] initWithDate:[dateFormat dateFromString:@"2012-09-11"]
                                             andDescription:@"Tikka Masala" andHours:0.5 andProject:project2 andIsSubmitted:NO andIsApproved:NO];
    
    Registration *reg3 = [[Registration alloc] initWithDate:[dateFormat dateFromString:@"2012-09-12"]
                                             andDescription:@"Helstekt gris" andHours:0.5 andProject:project2 andIsSubmitted:NO andIsApproved:NO];
    
    
    NSArray *registrations = [[NSArray alloc] initWithObjects:reg1, reg2, reg3, nil];
    
    return [[Week alloc] initWithStartDate:[dateFormat dateFromString:@"2012-09-10"] endDate:[dateFormat dateFromString:@"2012-09-16"] andRegistrations:registrations];
}

- (void)sendRequests {
    // Perform a simple HTTP GET and call me back with the results
    [ [RKClient sharedClient] get:@"/hours/week" delegate:self];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK])
        {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
            Week *w = [[Week alloc] init];
            if(self.receiver)
            {
                [self.receiver didReceiveWeek:w];
            }
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
