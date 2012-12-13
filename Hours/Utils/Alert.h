//
//  Alert.h
//  Hours
//
//  Created by Tommy Wendelborg on 12/13/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alert : NSObject
+(UIAlertView *) createAlertWithTitle:(NSString *)title andMessage:(NSString *) message;
+(UIAlertView *) createOkCancelAlertWithTitle:(NSString *)title andMessage:(NSString *) message forDelegate:(id) delegate;
@end
