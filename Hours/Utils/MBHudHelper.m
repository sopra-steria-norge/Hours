//
//  MBHudHelper.m
//  Hours
//
//  Created by Tommy Wendelborg on 12/8/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "MBHudHelper.h"

@implementation MBHudHelper

+ (MBProgressHUD *)ShowSpinnerForDelegate:(id<MBProgressHUDDelegate>)delegate withView:(UIView *)view andMessage:(NSString*) message
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [view addSubview:hud];
    hud.delegate = delegate;
    hud.labelText = message;
    [hud show:YES];
    return hud;
}

+ (MBProgressHUD *)ShowSpinnerForDelegate:(id<MBProgressHUDDelegate>)delegate withView:(UIView *)view
{
    return [MBHudHelper ShowSpinnerForDelegate:delegate withView:view andMessage:NSLocalizedString(@"LOADING", nil)];
}

+ (void)HideSpinnerForHud:(MBProgressHUD *)hud
{
    [hud show:NO];
    [hud removeFromSuperview];
}

@end
