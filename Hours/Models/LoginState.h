//
//  LoginState.h
//  Hours
//
//  Created by Tommy Wendelborg on 12/7/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginState;
@protocol LoginStateReceiver <NSObject>
- (void)didReceiveLoginState:(LoginState *) loginState;
- (void)didFailLoggingInWithError:(NSError *)error;
@end

@interface LoginState : NSObject
@property (nonatomic, readonly, strong) NSString * userName;
@property (nonatomic, readonly, strong) NSString * passwordHash;

+ (void) LoginWithUserName:(NSString *)userName andPassword:(NSString *)password forReceiver:(id<LoginStateReceiver>) receiver;
@end
