//
//  Week.m
//  Hours
//
//  Created by Tommy Wendelborg on 9/20/12.
//  Copyright (c) 2012 Steria. All rights reserved.
//

#import "Week.h"
@implementation Week {
    NSDateFormatter *dateFormatter;
}

@synthesize days = _days;
@synthesize description = _description;
@synthesize normTime = _normTime;
@synthesize projects = _projects;
@synthesize downloadTimestamp = _downloadTimestamp;
@synthesize isSubmitted = _isSubmitted;
@synthesize isApproved = _isApproved;

-(id) init
{
    self = [super init];
    dateFormatter = [Week createDateFormatter];
    
    return self;
}

+ (NSDateFormatter *) createDateFormatter
{
    NSDateFormatter *formatter = formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
    return formatter;
}

@end
