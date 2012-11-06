//
//  Registration.m
//  iSwhrs
//
//  Created by Tommy Wendelborg on 9/20/12.
//  Copyright (c) 2012 Steria. All rights reserved.
//

#import "Registration.h"

@interface Registration()

@property(nonatomic, readwrite, copy) NSDate *date;
@property(nonatomic, readwrite) double hours;
@property(nonatomic, readwrite, copy) NSString *projectCode;
@property(nonatomic, readwrite, copy) NSString *description;
@property(nonatomic, readwrite) BOOL isSubmitted;
@property(nonatomic, readwrite) BOOL isApproved;

@end

@implementation Registration

@synthesize date = _date;
@synthesize hours = _hours;
@synthesize projectCode = _projectCode;
@synthesize description = _description;
@synthesize isSubmitted = _isSubmitted;
@synthesize isApproved = _isApproved;

- (id) initWithDate:(NSDate *) date andDescription:(NSString *) description andHours:(double) hours andProjectCode:(NSString *) projectCode andIsSubmitted:(BOOL) isSubmitted andIsApproved:(BOOL) isApproved
{
    self = [super init];
    if(self)
    {
        self.date = date;
        self.hours = hours;
        self.projectCode = projectCode;
        self.description = description;
        self.isSubmitted = isSubmitted;
        self.isApproved = isApproved;
    }
    return self;
}

@end
