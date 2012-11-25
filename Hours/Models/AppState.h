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

@property(nonatomic, strong) Week *currentWeek;
@property(nonatomic, readonly, weak) Day *currentDay;
@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, readonly, weak) NSDate *nextDate;
@property(nonatomic, readonly, weak) NSDate *previousDate;
@property(nonatomic, readonly, weak) NSString *currentDayTitle;

- (bool) isLocked;

- (id) initWithDate:(NSDate *) date;
- (Day *) getDayForDate:(NSDate *) date;
- (Project *) getProjectByNumber:(NSString *) projectNumber andActivityCode:(NSString *)activityCode;
- (AppState *) navigateNextDay;
- (AppState *) navigatePreviousDay;
- (AppState *) navigateNextWeek;
- (AppState *) navigatePreviousWeek;

- (NSString *)getTitleForDate:(NSDate *) date;


@property(nonatomic, readonly, strong) NSArray *registrationsToSave;
- (void) addExistingRegistrationToSaveQueue:(Registration *)existingRegistration;
- (void) addNewRegistrationToSaveQueueWithProjectNumber:(NSString *)projectNumber activityCode:(NSString *)activityCode hours:(double) hours andDescription:(NSString *)description;

+ (AppState *) deserializeOrLoadForReceiver:(id<AppStateReceiver>) receiver;
+ (void) clear;
@end
