//
//  Registration.h
//  iSwhrs
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
@property(nonatomic, readonly, strong) Project *project;
@property(nonatomic, readonly) BOOL isSubmitted;
@property(nonatomic, readonly) BOOL isApproved;

- (id) initWithDate:(NSDate *) date andDescription:(NSString *) description andHours:(double) hours andProject:(Project *) project andIsSubmitted:(BOOL) isSubmitted andIsApproved:(BOOL) isApproved;

@end
