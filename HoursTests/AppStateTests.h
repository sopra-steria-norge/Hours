//
//  AppStateTests.h
//  Hours
//
//  Created by Tommy Wendelborg on 12/15/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import "AppState.h"

#define STAssertDateStringEqualsDate(expectedDateString, date) \
do { \
NSDate *expected = [self.formatter dateFromString:expectedDateString];\
STAssertTrue([expected isEqualToDate:date], @"Expected date %@, got: %@", expectedDateString, [self.formatter stringFromDate:date]);\
} while(0)

@interface AppStateTests : SenTestCase

@end
