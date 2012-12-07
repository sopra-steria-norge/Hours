//
//  LoginState.m
//  Hours
//
//  Created by Tommy Wendelborg on 12/7/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "LoginState.h"

@implementation LoginState

@synthesize userName = _userName;
@synthesize passwordHash = _passwordHash;

+ (void) LoginWithUserName:(NSString *)userName andPassword:(NSString *)password forReceiver:(id<LoginStateReceiver>) receiver
{
    // TODO
}



@end
