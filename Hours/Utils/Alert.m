//
//  Alert.m
//  Hours
//
//  Created by Tommy Wendelborg on 12/13/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "Alert.h"

@implementation Alert
+(UIAlertView *) createAlertWithTitle:(NSString *)title andMessage:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OKBUTTON", nil)
                                          otherButtonTitles:nil];
    return alert;
}

+(UIAlertView *) createOkCancelAlertWithTitle:(NSString *)title andMessage:(NSString *) message forDelegate:(id) delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:NSLocalizedString(@"OKBUTTON", nil)
                                          otherButtonTitles:NSLocalizedString(@"CANCELBUTTON", nil), nil];
    return alert;
}

@end
