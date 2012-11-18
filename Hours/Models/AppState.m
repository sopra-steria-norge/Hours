//
//  AppState.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "AppState.h"
#import "DataFactory.h"

@interface AppState()
@end

@implementation AppState

const char *url = "http://fakeswhrs.azurewebsites.net/";

@synthesize currentDate = _currentDate;
@synthesize currentDay = _currentDay;
@synthesize timestampForDownload = _timestampForDownload;
@synthesize week = _week;

static DataFactory *_dataFactory;

- (id) initWithDate:(NSDate *) date {
    self = [self init];
    if(self)
    {
        self.currentDate = date;
        self.timestampForDownload = date;
    }
    return self;
}

+ (DataFactory *)dataFactory
{
    if(!_dataFactory)
    {
        _dataFactory = [[DataFactory alloc] init];
    }
    return _dataFactory;
}

- (Day *) currentDay
{
    return [self getDayForDate:self.currentDate];
}

- (Day *) getDayForDate:(NSDate *) date
{
    for(Day *d in self.week.days)
    {
        if([date isEqualToDate:d.date])
        {
            return d;
        }
    }
    return nil;
}

- (AppState *) nextDay
{
    // TODO: Navigate
    return self;
}
- (AppState *) previousDay
{
    // TODO: Navigate
    return self;
}

- (AppState *) nextWeek
{
    // TODO: Navigate
    return self;
}

- (AppState *) previousWeek
{
    // TODO: Navigate
    return self;
}

- (Project *) getProjectByNumber:(NSString *) projectNumber
{
    for(Project *p in self.week.projects)
    {
        if([p.projectNumber isEqualToString:projectNumber])
        {
            return p;
        }
    }
    return nil;
}


+(AppState *) deserializeOrLoadForReceiver:(id<AppStateReceiver>) receiver;
{
    AppState *state = [DataFactory sharedState];
    if(!state)
    {
        NSURL *url = [NSURL URLWithString:@"http://fakeswhrs.azurewebsites.net/"];
        [[AppState dataFactory] startGetDataFromUrl:url forDate:[[NSDate alloc] init] andDelegateReceiver:receiver];
    }

    return state;
}

+ (void) clear
{
    [DataFactory clearState];
}

@end
