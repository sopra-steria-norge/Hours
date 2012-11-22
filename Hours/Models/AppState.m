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
@property(nonatomic, strong) NSMutableArray *registrationsToSave;
@end

@implementation AppState

NSString * const URL = @"http://fakeswhrs.azurewebsites.net/";
const int ONE_DAY_IN_SECONDS = 60*60*24;

@synthesize currentDay = _currentDay;
@synthesize currentDate = _currentDate;
@synthesize currentWeek = _currentWeek;
@synthesize previousDate = _previousDate;
@synthesize nextDate = _nextDate;
@synthesize registrationsToSave = _registrationsToSave;

static DataFactory *_dataFactory;

- (id) initWithDate:(NSDate *) date
{
    self = [self init];
    if(self)
    {
        self.currentDate = date;
    }
    return self;
}

- (id) init
{
    self = [super init];
    if(self)
    {
        self.registrationsToSave = [[NSMutableArray alloc] init];
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
    for(Day *d in self.currentWeek.days)
    {
        if([date isEqualToDate:d.date])
        {
            return d;
        }
    }
    return nil;
}

- (NSDate *)previousDate
{
    return [self.currentDate dateByAddingTimeInterval:ONE_DAY_IN_SECONDS];
}

- (NSDate *)nextDate
{
    return [self.currentDate dateByAddingTimeInterval:ONE_DAY_IN_SECONDS * -1];
}

- (AppState *) navigateNextDay
{
    self.currentDate = [self previousDate];
    return self;
}
- (AppState *) navigatePreviousDay
{
    self.currentDate = [self nextDate];
    return self;
}

- (AppState *) navigateNextWeek
{
    // TODO: Navigate
    return self;
}

- (AppState *) navigatePreviousWeek
{
    // TODO: Navigate
    return self;
}

- (Project *) getProjectByNumber:(NSString *) projectNumber andActivityCode:(NSString *)activityCode
{
    for(Project *p in self.currentWeek.projects)
    {
        if([p.projectNumber isEqualToString:projectNumber] && [p.activityCode isEqualToString:activityCode])
        {
            return p;
        }
    }
    return nil;
}

- (NSArray *) registrationsToSave
{
    return _registrationsToSave.copy;
}

- (void) addExistingRegistrationToSaveQueue:(Registration *)existingRegistration
{
    [self addRegistrationForUpdate:existingRegistration];
}
- (void) addNewRegistrationToSaveQueueWithProjectNumber:(NSString *)projectNumber activityCode:(NSString *)activityCode hours:(double) hours andDescription:(NSString *)description
{
    Registration *registration = [[Registration alloc] init];
    registration.projectNumber = projectNumber;
    registration.activityCode = activityCode;
    registration.hours = hours;
    registration.description = description;

    [self addRegistrationForUpdate:registration];
}

- (void)addRegistrationForUpdate:(Registration *)registration {
    NSMutableArray *mutableCopy = _registrationsToSave.mutableCopy;
    [mutableCopy addObject:registration];
    _registrationsToSave = mutableCopy.copy;
}

+(AppState *) deserializeOrLoadForReceiver:(id<AppStateReceiver>) receiver;
{
    AppState *state = [DataFactory sharedState];
    if(!state)
    {
        NSURL *url = [NSURL URLWithString:URL];
        [[AppState dataFactory] startGetDataFromUrl:url forDate:[[NSDate alloc] init] andDelegateReceiver:receiver];
    }

    return state;
}

+ (void) clear
{
    [DataFactory clearState];
}

@end
