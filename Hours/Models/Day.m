//
//  Day.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/7/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "Day.h"
#import "Registration.h"

@implementation Day

NSString * const LUNCH_ACTIVITY_CODE = @"LU";
const double LUNCH_LENGTH = 0.5;

@synthesize date = _date;
@synthesize registrations = _registrations;

-(NSString *) getSummary
{
    bool lunch = NO;
    NSString *result = @"";
    
    for(Registration *r in self.registrations)
    {
        if([r.activityCode isEqualToString:LUNCH_ACTIVITY_CODE] && r.hours == LUNCH_LENGTH)
        {
            lunch = YES;
        }
        else
        {
            if(result.length > 0)
            {
                result = [result stringByAppendingString:@", "];
            }
            result = [result stringByAppendingFormat:@"%@: %.1fh", r.projectNumber, r.hours];
        }
    }
    
    if(lunch)
    {
        NSString *temp = @"[L] ";
        result = [temp stringByAppendingString:result];
    }
    
    return result;
}

@end
