//
//  AppState.m
//  iSwhrs-native
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "AppState.h"
#import "DataFactory.h"

@interface AppState()

@property(nonatomic, readwrite, strong) NSDate *currentDate;
@property(nonatomic, readwrite, strong) Week *week;

@end

@implementation AppState

@synthesize currentDate = _currentDate;
@synthesize week = _week;


-(id) initWithDate:(NSDate *) date {
    self = [self init];
    if(self)
    {
        self.currentDate = date;
        Week *week = [[Week alloc] init]; // TODO Get data
        self.week = week;
    }
    return self;
}
@end
