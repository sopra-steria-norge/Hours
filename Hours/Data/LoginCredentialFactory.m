//
//  LoginCredentialFactory.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/28/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "LoginCredentialFactory.h"

@interface LoginCredentialFactory()<RandomGenerator>
@end

@implementation LoginCredentialFactory
@synthesize randomGenerator = _randomGenerator;

NSString * const base64Alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

-(NSString *) saltAndHash:(NSString *)password
{
    NSString *saltedAndHashed = password.copy;
    return saltedAndHashed;
}
-(NSString *) randomBase64String
{
    int stringLength = 8;
    NSMutableString *randomString = [[NSMutableString alloc] init];
    for (int i = 0; i < stringLength; i++)
    {
        int index = [self.randomGenerator getRandomNumber] % base64Alphabet.length;
        unichar character = [base64Alphabet characterAtIndex:index];
        [randomString appendString:[NSString stringWithCharacters:&character length:1]];
    }
    return randomString.copy;
}

-(id<RandomGenerator>) randomGenerator
{
    if(!_randomGenerator)
    {
        _randomGenerator = self;
    }
    return _randomGenerator;
}

-(void) setRandomGenerator:(id<RandomGenerator>)randomGenerator
{
    _randomGenerator = randomGenerator;
}


- (int) getRandomNumber
{
    return arc4random();
}

@end
