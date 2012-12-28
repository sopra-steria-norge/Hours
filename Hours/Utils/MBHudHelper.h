//
//  MBHudHelper.h
//  Hours
//
//  Created by Tommy Wendelborg on 12/8/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MBHudHelper : NSObject
+ (MBProgressHUD *)ShowSpinnerForDelegate:(id<MBProgressHUDDelegate>)delegate withView:(UIView *)view andMessage:(NSString*) message;
+ (MBProgressHUD *)ShowSpinnerForDelegate:(id<MBProgressHUDDelegate>)delegate withView:(UIView *)view;
+ (void)HideSpinnerForHud:(MBProgressHUD *)hud;
@end
