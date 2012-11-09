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

@property(nonatomic, readonly, copy) NSString *registrationNumber;
@property(nonatomic, readonly, copy) NSString *activityCode;
@property(nonatomic, readonly, copy) NSString *workType;
@property(nonatomic, readonly, copy) NSString *description;
@property(nonatomic, readonly) double hours;
@property(nonatomic, readonly, copy) NSString *projectNumber;
@property(nonatomic, readonly) BOOL submitted;
@property(nonatomic, readonly) BOOL approved;
@property(nonatomic, readonly) BOOL rejected;

@end
