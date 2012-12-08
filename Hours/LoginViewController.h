//
//  LoginViewController.h
//  Hours
//
//  Created by Tommy Wendelborg on 11/9/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginState.h"

@interface LoginViewController : UIViewController
@property (nonatomic, readonly, strong) LoginState *loginState;
@end
