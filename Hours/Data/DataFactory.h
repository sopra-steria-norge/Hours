//
//  DataFactory.h
//  Hours
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeekReceiver.h"
#import "Week.h"

@interface DataFactory : NSObject
@property(nonatomic, weak) id<WeekReceiver> receiver;
-(void) startGetDataForDate:(NSDate *)date andDelegateReceiver:(id<WeekReceiver>) receiver;
@end
