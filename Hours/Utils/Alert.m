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
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    return alert;
}

+(UIAlertView *) createOkCancelAlertWithTitle:(NSString *)title andMessage:(NSString *) message forDelegate:(id) delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Cancel", nil];
    return alert;
}

@end
