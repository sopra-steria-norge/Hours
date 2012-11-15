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
@property(nonatomic, readonly, strong) DataFactory *dataFactory;
@end

@implementation AppState

const char *url = "http://fakeswhrs.azurewebsites.net/";

@synthesize currentDate = _currentDate;
@synthesize currentDay = _currentDay;
@synthesize timestampForDownload = _timestampForDownload;
@synthesize week = _week;
@synthesize dataFactory = _dataFactory;


- (id) initWithDate:(NSDate *) date {
    self = [self init];
    if(self)
    {
        self.currentDate = date;
        self.timestampForDownload = date;
    }
    return self;
}

- (DataFactory *)dataFactory
{
    if(!_dataFactory)
    {
        _dataFactory = [[DataFactory alloc] init];
    }
    return _dataFactory;
}

- (void) startDownloadFromUrl:(NSURL *)url forDate:(NSDate *)date andDelegateReceiver:(id<AppStateReceiver>) receiver
{
    self.currentDate = date;
    [self.dataFactory startGetDataFromUrl:url forDate:date andDelegateReceiver:receiver];
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
    // TODO: Try to deserialize first, check timestampForDownload (if older than 5 minutes or so download again)
    // TODO: If could not deserialize, download the data:
    AppState *state = [[AppState alloc] initWithDate:[[NSDate alloc] init]];
    NSURL *url = [NSURL URLWithString:@"http://fakeswhrs.azurewebsites.net/"];
   [state startDownloadFromUrl:url forDate: state.currentDate andDelegateReceiver:receiver];

    return state;
}

@end
