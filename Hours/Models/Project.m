//
//  Project.m
//  Hours
//
//  Created by Tommy Wendelborg on 9/20/12.
//  Copyright (c) 2012 Steria. All rights reserved.
//

#import "Project.h"

@interface Project()

@property (nonatomic, readwrite, copy) NSString *projectCode;
@property (nonatomic, readwrite, copy) NSString *projectNumber;
@property (nonatomic, readwrite, copy) NSString *projectName;
@property (nonatomic, readwrite, copy) NSString *activityCode;
@property (nonatomic, readwrite, copy) NSString *description;

@end

@implementation Project

@synthesize projectCode = _projectCode;
@synthesize projectNumber = _projectNumber;
@synthesize projectName = _projectName;
@synthesize activityCode = _activityCode;
@synthesize description = _description;

@end
