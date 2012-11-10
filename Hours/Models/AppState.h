//
//  AppState.h
//  Hours
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Week.h"
#import "WeekReceiver.h"

@interface AppState : NSObject

@property(nonatomic, readonly, strong) NSDate *currentDate;
@property(nonatomic, readonly, strong) NSDate *timestampForDownload;
@property(nonatomic, readonly, strong) Week *week;
-(id) initWithDate:(NSDate *) date;
-(void) startDownloadForDate:(NSDate *)date  andDelegateReceiver:(id<WeekReceiver>) receiver;
+(AppState *) deserializeOrLoadForReceiver:(id<WeekReceiver>) receiver;
@end
