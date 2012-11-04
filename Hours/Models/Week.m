//
//  Week.m
//  iSwhrs
//
//  Created by Tommy Wendelborg on 9/20/12.
//  Copyright (c) 2012 Steria. All rights reserved.
//

#import "Week.h"
#import "Registration.h"

@interface Week ()
@property(nonatomic, strong) NSMutableArray *registrations;
@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;
@end

@implementation Week {
    NSDateFormatter *dateFormatter;
}

@synthesize registrations = _registrations;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;


-(id) init
{
    self = [super init];
    dateFormatter = [Week createDateFormatter];
    
    return self;
}

- (id) initWithStartDate: (NSDate *) startDate endDate: (NSDate *) endDate andRegistrations:(NSArray *) registrations
{
    self = [self init];
    if(self)
    {
        self.startDate = startDate;
        self.endDate = endDate;
        self.registrations = [registrations mutableCopy];
    }
    return self;
}

+ (NSDateFormatter *) createDateFormatter
{
    NSDateFormatter *formatter = formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
    return formatter;
}

- (NSArray *)projectsForWeek
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for(Registration *r in self.registrations)
    {
        Project *p = r.project;
        if(p != nil && ![tempArray containsObject:p])
        {
            [tempArray addObject:p];
        }
    }
    return tempArray.copy;
}

- (Registration *)registrationForDay:(NSDate*)day andProject:(Project *)project
{
    for(Registration *r in self.registrations)
    {
        if([r.date isEqualToDate:day] && r.project == project)
        {
            return r;
        }
    }
    return nil;
}

- (NSArray *) registrationsForDay:(NSDate *) day {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for(Registration *r in self.registrations)
    {
        if([r.date isEqualToDate: day])
        {
            [tempArray addObject:r];
        }
    }
    
    return tempArray.copy;
}

- (double) sumRegistrations
{
    double sum = 0;
    for(Registration *r in self.registrations)
    {
        sum += r.hours;
    }
    
    return sum;
}

- (NSString *)getDetailStringFromWeek
{
    return [NSString stringWithFormat:@"%.2f", self.sumRegistrations];
}

- (NSString *)getPeriodString
{
    NSString *dateInfo = [[[dateFormatter stringFromDate:self.startDate]
                           stringByAppendingString:@" - "]
                          stringByAppendingString:[dateFormatter stringFromDate:self.endDate]];
    return dateInfo;
}


@end
