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

@property(nonatomic, readonly, copy) NSDate *date;
@property(nonatomic, readonly, copy) NSString *description;
@property(nonatomic, readonly) double hours;
@property(nonatomic, readonly, copy) NSString *projectCode;
@property(nonatomic, readonly) BOOL isSubmitted;
@property(nonatomic, readonly) BOOL isApproved;

- (id) initWithDate:(NSDate *) date andDescription:(NSString *) description andHours:(double) hours andProjectCode:(NSString *) projectCode andIsSubmitted:(BOOL) isSubmitted andIsApproved:(BOOL) isApproved;

@end
