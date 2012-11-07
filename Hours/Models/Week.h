//
//  Week.h
//  Hours
//
//  Created by Tommy Wendelborg on 9/20/12.
//  Copyright (c) 2012 Steria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Registration.h"

@interface Week : NSObject
@property(nonatomic, readonly, strong) NSDictionary *registrations;
- (id) initWithStartDate: (NSDate *) startDate endDate: (NSDate *) endDate andRegistrations:(NSArray *) registrations;
//- (NSArray *)projectsForWeek; // TODO: must be made to find project by projectCode, thanks to model rewrites
- (double) sumRegistrations;
- (NSString *)getDetailStringFromWeek;
- (NSString *)getPeriodString;
@end
