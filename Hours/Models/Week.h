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
@property(nonatomic, readonly, strong) NSDictionary *days;
@property(nonatomic, readonly, copy) NSString *description;
@property(nonatomic, readonly, copy) NSString * normTime;
@end
