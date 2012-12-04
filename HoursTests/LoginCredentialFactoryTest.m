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
@property(nonatomic, strong) RandomGeneratorFake *randomGeneratorFake;
@end

@implementation LoginCredentialFactoryTest

NSString const * expectedSalt = @"BBBBBBBB";
NSString const * password = @"pass_word";

@synthesize loginCredentialFactory = _loginCredentialFactory;
@synthesize randomGeneratorFake = _randomGeneratorFake;

- (void)setUp
{
    [super setUp];
    
    self.loginCredentialFactory = [[LoginCredentialFactory alloc] init];
    self.randomGeneratorFake = [[RandomGeneratorFake alloc] initWithFixedBaseStringAlphatIndex:1];
    self.loginCredentialFactory.randomGenerator = self.randomGeneratorFake;
}

- (void)tearDown
{
    // Tear-down code here.
    self.loginCredentialFactory = nil;
    self.randomGeneratorFake = nil;
    [super tearDown];
}

- (void)test_randomBase64String_mustReturnEightBs_givenFakeRandomIndex1;
{
    NSString *randomString = [self.loginCredentialFactory randomBase64String];
    STAssertTrue([expectedSalt isEqualToString:randomString], @"Expected %@, got %@", expectedSalt, randomString);
}

- (void)test_saltAndHash_mustReturnSaltAsFirst8characters;
{
    NSString *salted = [self executeSaltAndHash];
    NSString *first8characters = [salted substringToIndex:8];
    
    STAssertTrue([expectedSalt isEqualToString:first8characters], @"Wrong result in salted password, first 8 characters: %@", first8characters);
}

- (NSString *)executeSaltAndHash
{
    return [self.loginCredentialFactory saltAndHash:password.copy];
}

@end
