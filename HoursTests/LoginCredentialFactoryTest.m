//
//  LoginCredentialFactoryTest.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/29/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "LoginCredentialFactoryTest.h"
#import "RandomGeneratorFake.h"

@interface LoginCredentialFactoryTest()
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) RandomGeneratorFake *randomGeneratorFake;
@end

@implementation LoginCredentialFactoryTest
@synthesize loginCredentialFactory = _loginCredentialFactory;
@synthesize password = _password;
@synthesize randomGeneratorFake = _randomGeneratorFake;

- (void)setUp
{
    [super setUp];
    
    self.loginCredentialFactory = [[LoginCredentialFactory alloc] init];
    self.randomGeneratorFake = [[RandomGeneratorFake alloc] init];
    self.loginCredentialFactory.randomGenerator = self.randomGeneratorFake;
    self.password = @"pass_word";
}

- (void)tearDown
{
    // Tear-down code here.
    self.loginCredentialFactory = nil;
    self.randomGeneratorFake = nil;
    self.password = nil;
    [super tearDown];
}

- (void)test_randomBase64String_mustReturnEightBs_givenFakeRandomIndex1;
{
    self.randomGeneratorFake.numberToReturn = 1;
    NSString *randomString = [self.loginCredentialFactory randomBase64String];
    NSString const * expected = @"BBBBBBBB";
    STAssertTrue([expected isEqualToString:randomString], @"Expected %@, got %@", expected, randomString);
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
