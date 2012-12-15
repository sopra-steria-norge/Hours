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
    
    STAssertTrue([today isEqualToDate:currentDay], @"Current day was not initialized with %@, got: %@", [self.formatter stringFromDate:today], [self.formatter stringFromDate:currentDay]);
}

- (void)testMustReturnYesterdayAsPreviousDate
{
    NSDate *previousDate = self.appState.previousDate;
    NSDate *yesterday = self.yesterday;
    
    STAssertTrue([yesterday isEqualToDate:previousDate], @"Current day was not initialized with %@, got: %@", [self.formatter stringFromDate:yesterday], [self.formatter stringFromDate:previousDate]);
}


- (void)testMustReturnTomorrowAsNextDate
{
    NSDate *nextDate = self.appState.nextDate;
    NSDate *tomorrow = self.tomorrow;
    
    STAssertTrue([tomorrow isEqualToDate:nextDate], @"Current day was not initialized with %@, got: %@", [self.formatter stringFromDate:tomorrow], [self.formatter stringFromDate:nextDate]);
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


@end
