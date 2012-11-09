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
@property(nonatomic, copy) NSString *activityCode;
@property(nonatomic, copy) NSString *workType;
@property(nonatomic) double hours;
@property(nonatomic, copy) NSString *projectNumber;
@property(nonatomic, copy) NSString *description;
@property(nonatomic) BOOL submitted;
@property(nonatomic) BOOL approved;
@property(nonatomic) BOOL rejected;


@end

@implementation Registration

@synthesize registrationNumber = _registrationNumber;
@synthesize activityCode = _activityCode;
@synthesize workType = _workType;
@synthesize hours = _hours;
@synthesize projectNumber = _projectNumber;
@synthesize description = _description;
@synthesize submitted = _submitted;
@synthesize approved = _approved;
@synthesize rejected = _rejected;

@end
