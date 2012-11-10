//
//  Project.h
//  Hours
//
//  Created by Tommy Wendelborg on 9/20/12.
//  Copyright (c) 2012 Steria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject

@property (nonatomic, copy) NSString *projectCode;
@property (nonatomic, copy) NSString *projectNumber;
@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString *activityCode;
@property (nonatomic, copy) NSString *description;

@end
