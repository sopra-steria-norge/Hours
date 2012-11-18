//
//  AppState.h
//  Hours
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Week.h"

@class AppState;
@protocol AppStateReceiver <NSObject>
- (void)didReceiveAppState:(AppState *) appState;
- (void)didFailLoadingAppStateWithError:(NSError *)error;
@end

@interface AppState : NSObject

@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, readonly, weak) Day *currentDay;
@property(nonatomic, strong) NSDate *timestampForDownload;
@property(nonatomic, strong) Week *week;

- (id) initWithDate:(NSDate *) date;
- (Day *) getDayForDate:(NSDate *) date;
- (Project *) getProjectByNumber:(NSString *) projectNumber;
- (AppState *) nextDay;
- (AppState *) previousDay;
- (AppState *) nextWeek;
- (AppState *) previousWeek;

+ (AppState *) deserializeOrLoadForReceiver:(id<AppStateReceiver>) receiver;
+ (void) clear;
@end
