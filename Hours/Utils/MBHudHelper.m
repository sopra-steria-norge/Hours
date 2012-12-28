//
//  MBHudHelper.m
//  Hours
//
//  Created by Tommy Wendelborg on 12/8/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "MBHudHelper.h"

@implementation MBHudHelper

+ (MBProgressHUD *)ShowSpinnerForDelegate:(id<MBProgressHUDDelegate>)delegate withView:(UIView *)view
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [view addSubview:hud];
    hud.delegate = delegate;
    hud.labelText = NSLocalizedString(@"LOADING", nil);
    [hud show:YES];
    return hud;
}

+ (void)HideSpinnerForHud:(MBProgressHUD *)hud
{
    [hud show:NO];
    [hud removeFromSuperview];
}

@end
