//
//  AppStateTests.m
//  Hours
//
//  Created by Tommy Wendelborg on 12/15/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "AppStateTests.h"

@interface AppStateTests()
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) AppState *appState;
@end

@implementation AppStateTests

@synthesize formatter = _formatter;
@synthesize appState = _appState;

NSString * const twoDaysFromNowString   = @"20121212";
NSString * const tomorrowString         = @"20121211";
NSString * const todayString            = @"20121210";
NSString * const yesterdayString        = @"20121209";
NSString * const twoDaysAgoString       = @"20121208";

- (void)setUp
{
    [super setUp];
    
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.timeStyle = NSDateFormatterNoStyle;
    self.formatter.dateFormat = @"yyyyMMdd";
    
    self.appState = [[AppState alloc] initWithDate:[self.formatter dateFromString:todayString]];
    self.appState.currentWeek = [self createTestWeekWithYesterdayTodayAndTomorrow];
}

- (void)tearDown
{
    // Tear-down code here.
    [self setFormatter:nil];
    [self setAppState:nil];
    [super tearDown];
}

- (void)testMustReturnTodayAsCurrentDate
{
    NSDate *currentDay = self.appState.currentDate;
    NSDate *expected = [self.formatter dateFromString:todayString];
    
    STAssertTrue([expected isEqualToDate:currentDay], @"Current day was not initialized with %@, got: %@",
                 todayString, [self.formatter stringFromDate:currentDay]);
}

- (void) testSetupMustHavePeriodWithThreeDaysAndCurrentDayInTheMiddle
{
    NSDate *twoDaysFromNow = [self.formatter dateFromString:twoDaysFromNowString];
    NSDate *tomorrow = [self.formatter dateFromString:tomorrowString];
    NSDate *today = [self.formatter dateFromString:todayString];
    NSDate *yesterday = [self.formatter dateFromString:yesterdayString];
    NSDate *twoDaysAgo = [self.formatter dateFromString:twoDaysAgoString];
    
    STAssertTrue([today isEqualToDate:self.appState.currentDate], @"Bad test setup");
    STAssertNotNil(self.appState.currentDay, @"Bad test setup");
    STAssertNotNil([self.appState getDayForDate:tomorrow], @"Bad test setup");
    STAssertNotNil([self.appState getDayForDate:yesterday], @"Bad test setup");
                    
    STAssertNil([self.appState getDayForDate:twoDaysFromNow], @"Bad test setup");
    STAssertNil([self.appState getDayForDate:twoDaysAgo], @"Bad test setup");
}

- (void)testMustReturnYesterdayAsPreviousDate
{
    NSDate *previousDate = self.appState.previousDate;
    
    STAssertDateStringEqualsDate(yesterdayString, previousDate);
}

- (void)testMustReturnTomorrowAsNextDate
{
    NSDate *nextDate = self.appState.nextDate;
    STAssertDateStringEqualsDate(tomorrowString, nextDate);
}

- (void) testNavigateNextDay_mustSetCurrentDateToTomorrow
{
    AppState *updatedState = [self.appState navigateNextDay];
    STAssertDateStringEqualsDate(tomorrowString, updatedState.currentDate);
}

- (void) testNavigatePreviousDay_mustSetCurrentDateToYesterday
{
    AppState *updatedState = [self.appState navigatePreviousDay];
    STAssertDateStringEqualsDate(yesterdayString, updatedState.currentDate);
}

- (void) testNavigatePreviousDay_mustSetCurrentWeekToNil_givenNoPreviousDayExists
{
    self.appState.currentDate = [self.formatter dateFromString:yesterdayString];
    AppState *updatedState = [self.appState navigatePreviousDay];
    
    STAssertNil(updatedState.currentWeek, @"Expected week to be nil, it is not");
}

- (void) testNavigatePreviousDay_mustSetCurrentDayToNil_givenNoPreviousDayExists
{
    self.appState.currentDate = [self.formatter dateFromString:yesterdayString];
    AppState *updatedState = [self.appState navigatePreviousDay];
    
    STAssertNil(updatedState.currentDay, @"Expected day to be nil, it is not");
}

- (void) testNavigateNextDay_mustSetCurrentWeekToNil_givenNoNextDayExists
{
    self.appState.currentDate = [self.formatter dateFromString:tomorrowString];
    AppState *updatedState = [self.appState navigateNextDay];
    
    STAssertNil(updatedState.currentWeek, @"Expected week to be nil, it is not");
}

- (void) testNavigateNextDay_mustSetCurrentDayToNil_givenNoNextDayExists
{
    self.appState.currentDate = [self.formatter dateFromString:tomorrowString];
    AppState *updatedState = [self.appState navigateNextDay];
    
    STAssertNil(updatedState.currentDay, @"Expected day to be nil, it is not");
}

- (void) testNavigateNextWeek_mustSetCurrentDateToCurrentWeekLastDatePlusOneDay
{
    AppState *updatedState = [self.appState navigateNextWeek];
    STAssertDateStringEqualsDate(twoDaysFromNowString, updatedState.currentDate);
};

- (void) testNavigatePrevioustWeek_mustSetCurrentDateToCurrentWeekLastDateMinusOneDay
{
    AppState *updatedState = [self.appState navigatePreviousWeek];
    STAssertDateStringEqualsDate(twoDaysAgoString, updatedState.currentDate);
};

- (Week *)createTestWeekWithYesterdayTodayAndTomorrow
{
    Week *w = [[Week alloc] init];

    Day *yesterday = [self createWithDate:[self.formatter dateFromString:yesterdayString]];
    Day *today = [self createWithDate:[self.formatter dateFromString:todayString]];
    Day *tomorow = [self createWithDate:[self.formatter dateFromString:tomorrowString]];
    
    w.days = [NSMutableArray arrayWithObjects:yesterday, today, tomorow, nil];
    
    return w;
}

- (Day *)createWithDate: (NSDate *)date
{
    Day *d = [[Day alloc] init];
    d.date = date;
    
    return d;
}

@end
