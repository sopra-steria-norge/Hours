//
//  LoginCredentialFactoryTest.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/29/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "LoginCredentialFactoryTest.h"

@interface LoginCredentialFactoryTest()
@property(nonatomic, strong) NSString *password;
@end

@implementation LoginCredentialFactoryTest
@synthesize loginCredentialFactory = _loginCredentialFactory;
@synthesize password = _password;

- (void)setUp
{
    [super setUp];
    
    self.loginCredentialFactory = [[LoginCredentialFactory alloc] init];
    self.password = @"pass_word";
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)test_saltAndHash_mustReturn_string;
{
    NSString *salted = [self executeSaltAndHash];
    STAssertNotNil(salted, @"No string returned from hashing");
}

- (NSString *)executeSaltAndHash
{
    return [self.loginCredentialFactory saltAndHash:self.password];
}

@end
