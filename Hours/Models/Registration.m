//
//  Registration.m
//  Hours
//
//  Created by Tommy Wendelborg on 9/20/12.
//  Copyright (c) 2012 Steria. All rights reserved.
//

#import "Registration.h"

@interface Registration()

@property(nonatomic, copy) NSString *registrationNumber;
@property(nonatomic, copy) NSDate *date;
@property(nonatomic) double hours;
@property(nonatomic, copy) NSString *projectCode;
@property(nonatomic, copy) NSString *description;
@property(nonatomic) BOOL isSubmitted;
@property(nonatomic) BOOL isApproved;

@end

@implementation Registration

@synthesize registrationNumber = _registrationNumber;
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
