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

@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, strong) NSDate *timestampForDownload;
@property(nonatomic, strong) Week *week;
@property(nonatomic, readonly, strong) DataFactory *dataFactory;

@end

@implementation AppState

@synthesize currentDate = _currentDate;
@synthesize timestampForDownload = _timestampForDownload;
@synthesize week = _week;
@synthesize dataFactory = _dataFactory;


-(id) initWithDate:(NSDate *) date {
    self = [self init];
    if(self)
    {
        self.currentDate = date;
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

-(void) startDownloadForDate:(NSDate *)date  andDelegateReceiver:(id<WeekReceiver>) receiver
{
    [self.dataFactory startGetDataForDate:date andDelegateReceiver:receiver];
}

+(AppState *) deserializeOrLoadForReceiver:(id<WeekReceiver>) receiver;
{
    // TODO: Try to deserialize first, check timestampForDownload (if older than 5 minutes or so download again)

    // TODO: If could not deserialize, download the data:
    AppState *state = [[AppState alloc] initWithDate:[[NSDate alloc] init]];
    [state startDownloadForDate: state.currentDate andDelegateReceiver:receiver];
    return state;
}

@end
