//
//  Week.h
//  iSwhrs
//
//  Created by Tommy Wendelborg on 9/20/12.
//  Copyright (c) 2012 Steria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Registration.h"

@interface Week : NSObject
@property(nonatomic, readonly, strong) NSDate *startDate;
@property(nonatomic, readonly, strong) NSDate *endDate;
@property(nonatomic, readonly, strong) NSArray *registrations;
- (id) initWithStartDate: (NSDate *) startDate endDate: (NSDate *) endDate andRegistrations:(NSArray *) registrations;
- (NSArray *)projectsForWeek;
- (Registration *)registrationForDay:(NSDate*)day andProject:(Project *)project;
- (NSArray *) registrationsForDay:(NSDate *)day;
- (double) sumRegistrations;
- (NSString *)getDetailStringFromWeek;
- (NSString *)getPeriodString;
@end
