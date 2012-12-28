//
//  Week.m
//  Hours
//
//  Created by Tommy Wendelborg on 9/20/12.
//  Copyright (c) 2012 Steria. All rights reserved.
//

#import "Week.h"
@implementation Week

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
    return self;
}

@end
