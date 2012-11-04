//
//  Project.m
//  iSwhrs
//
//  Created by Tommy Wendelborg on 9/20/12.
//  Copyright (c) 2012 Steria. All rights reserved.
//

#import "Project.h"

@interface Project()

@property (nonatomic, copy) NSString *projectNumber;
@property (nonatomic, copy) NSString *activityCode;
@property (nonatomic, copy) NSString *description;

@end

@implementation Project

@synthesize projectNumber = _projectNumber;
@synthesize activityCode = _activityCode;
@synthesize description = _description;

-(id)initWithprojectNumber:(NSString *) projectNumber andActivityCode:(NSString *) activityCode andDescription:(NSString *) description
{
    self = super.init;
    if(self)
    {
        self.projectNumber = projectNumber;
        self.activityCode = activityCode;
        self.description = description;
    }
    return self;
}

@end
