//
//  WeekReceiver.h
//  Hours
//
//  Created by Tommy Wendelborg on 11/5/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Week.h"

@protocol WeekReceiver <NSObject>
-(void)didReceiveWeek:(Week*) week;
@end
