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

- (void)setUp
{
    [super setUp];
    
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.timeStyle = NSDateFormatterNoStyle;
    self.formatter.dateFormat = @"yyyyMMdd";
    
    self.appState = [[AppState alloc] initWithDate:self.today];
    self.appState.currentWeek = [self testWeek];
}

- (void)tearDown
{
    // Tear-down code here.
    [self setFormatter:nil];
    [super tearDown];
}

- (void)testMustReturnTodayAsCurrentDate
{
    NSDate *currentDay = self.appState.currentDate;
    NSDate *today = self.today;
    
    STAssertTrue([today isEqualToDate:currentDay], @"Current day was not initialized with %@, got: %@",
                 [self.formatter stringFromDate:today], [self.formatter stringFromDate:currentDay]);
}

- (void)testMustReturnYesterdayAsPreviousDate
{
    NSDate *previousDate = self.appState.previousDate;
    NSDate *yesterday = self.yesterday;
    
    STAssertTrue([yesterday isEqualToDate:previousDate], @"Current day was not initialized with %@, got: %@",
                 [self.formatter stringFromDate:yesterday], [self.formatter stringFromDate:previousDate]);
}

- (void)testMustReturnTomorrowAsNextDate
{
    NSDate *nextDate = self.appState.nextDate;
    NSDate *tomorrow = self.tomorrow;
    
    STAssertTrue([tomorrow isEqualToDate:nextDate], @"Current day was not initialized with %@, got: %@",
                 [self.formatter stringFromDate:tomorrow], [self.formatter stringFromDate:nextDate]);
}

- (void) testNavigateNextDay_mustSetCurrentDateToTomorrow
{
    AppState *updatedState = [self.appState navigateNextDay];
    NSDate *tomorrow = self.tomorrow;
    STAssertTrue([tomorrow isEqualToDate:updatedState.currentDate], @"Next day was not initialized with %@, got: %@",
                 [self.formatter stringFromDate:tomorrow], [self.formatter stringFromDate:updatedState.currentDate]);
}

- (void) testNavigatePreviosDay_mustSetCurrentDateToYesterday
{
    AppState *updatedState = [self.appState navigatePreviousDay];
    NSDate *yesterday = self.yesterday;
    STAssertTrue([yesterday isEqualToDate:updatedState.currentDate], @"Next day was not initialized with %@, got: %@",
                 [self.formatter stringFromDate:yesterday], [self.formatter stringFromDate:updatedState.currentDate]);
}

- (NSDate *)today
{
    return [self.formatter dateFromString:@"20121210"];
}

- (NSDate *)yesterday
{
    return [self.formatter dateFromString:@"20121209"];
}

- (NSDate *)tomorrow
{
    return [self.formatter dateFromString:@"20121211"];
}


- (Week *)testWeek
{
    Week *w = [[Week alloc] init];

    Day *yesterday = [self createWithDate:[self yesterday]];
    Day *today = [self createWithDate:[self today]];
    Day *tomorow = [self createWithDate:[self tomorrow]];
    
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
