//
//  Day.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/7/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "Day.h"

@interface Day ()
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) NSMutableArray *registrations;
@end

@implementation Day
@synthesize date = _date;
@synthesize registrations = _registrations;


@end
