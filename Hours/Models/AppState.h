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
-(void)didReceiveAppState:(AppState *) appState;
@end

@interface AppState : NSObject

@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, strong) NSDate *timestampForDownload;
@property(nonatomic, strong) NSArray *projects;
@property(nonatomic, strong) Week *week;
-(id) initWithDate:(NSDate *) date;
-(void) startDownloadForDate:(NSDate *)date  andDelegateReceiver:(id<AppStateReceiver>) receiver;
+(AppState *) deserializeOrLoadForReceiver:(id<AppStateReceiver>) receiver;
@end
