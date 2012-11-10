//
//  Week.h
//  Hours
//
//  Created by Tommy Wendelborg on 9/20/12.
//  Copyright (c) 2012 Steria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Registration.h"
#import "Day.h"

@interface Week : NSObject
@property(nonatomic, strong) NSMutableArray *days;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString * normTime;
@end
