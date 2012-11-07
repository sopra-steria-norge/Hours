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
@property (nonatomic, strong) NSMutableArray *days;
@end

@implementation Day
@synthesize date = _date;
@synthesize days = _days;

-(void)setDays:(NSArray *)days
{
    self.days = [days mutableCopy];
}

-(NSArray *) days
{
    return self.days.copy;
}


@end
