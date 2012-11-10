//
//  Day.h
//  Hours
//
//  Created by Tommy Wendelborg on 11/7/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Day : NSObject
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) NSMutableArray *registrations;
@end
