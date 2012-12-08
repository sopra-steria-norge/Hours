//
//  LoginState.m
//  Hours
//
//  Created by Tommy Wendelborg on 12/7/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "LoginState.h"
#import "DataFactory.h"
#import "LoginCredentialFactory.h"

@interface LoginState ()
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * passwordHash;
@end

@implementation LoginState

static DataFactory *_dataFactory;

@synthesize userName = _userName;
@synthesize passwordHash = _passwordHash;

+ (LoginState *)loginWithUserName:(NSString *)userName andPassword:(NSString *)password forReceiver:(id<LoginStateReceiver>) receiver
{
    LoginState *loginState = [DataFactory sharedLoginState];
    if(!loginState || loginState.userName == nil || ![loginState.userName isEqualToString:userName])
    {
        loginState = [[LoginState alloc] init];
        loginState.userName = userName;        
        LoginCredentialFactory *credentialFactor = [[LoginCredentialFactory alloc] init];        
        loginState.passwordHash = [credentialFactor saltAndHash:password];

        [[LoginState dataFactory] startCheckAuthenticationForLoginState:loginState andDelegateReceiver:receiver];
        return nil;
    }
    return loginState;
}

+ (DataFactory *)dataFactory
{
    if(!_dataFactory)
    {
        _dataFactory = [[DataFactory alloc] init];
    }
    return _dataFactory;
}

@end
