//
//  Registration.h
//  Hours
//
//  Created by Tommy Wendelborg on 9/20/12.
//  Copyright (c) 2012 Steria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"

@interface Registration : NSObject

@property(nonatomic, copy) NSString *registrationNumber;
@property(nonatomic, copy) NSString *activityCode;
@property(nonatomic, copy) NSString *workType;
@property(nonatomic, copy) NSString *description;
@property(nonatomic) double hours;
@property(nonatomic, copy) NSString *projectNumber;
@property(nonatomic) BOOL submitted;
@property(nonatomic) BOOL approved;
@property(nonatomic) BOOL rejected;

@end
