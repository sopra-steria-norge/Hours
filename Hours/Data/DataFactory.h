//
//  DataFactory.h
//  Hours
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"AppState.h"
#import "Week.h"

@interface DataFactory : NSObject
@property(nonatomic, weak) id<AppStateReceiver> receiver;
-(void) startGetDataFromUrl: (NSURL *) url forDate:(NSDate *)date andDelegateReceiver:(id<AppStateReceiver>) receiver;
-(void) refreshDataForReceiver:(id<AppStateReceiver>) receiver;

+ (AppState*)sharedState;
@end
