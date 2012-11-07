//
//  AppState.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "AppState.h"
#import "DataFactory.h"

@interface AppState() <WeekReceiver>

@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, strong) Week *week;
@property(nonatomic, readonly, strong) DataFactory *dataFactory;

@end

@implementation AppState

@synthesize currentDate = _currentDate;
@synthesize week = _week;
@synthesize dataFactory = _dataFactory;


-(id) initWithDate:(NSDate *) date {
    self = [self init];
    if(self)
    {
        self.currentDate = date;
        [self.dataFactory startGetDataForDate:date andDelegateReceiver:self];
    }
    return self;
}

-(DataFactory *)dataFactory
{
    if(!_dataFactory)
    {
        _dataFactory = [[DataFactory alloc] init];
    }
    return _dataFactory;
}

-(void) didReceiveWeek:(Week *)week
{
    self.week = week;
}

@end
