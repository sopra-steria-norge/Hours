//
//  LoginCredentialFactory.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/28/12.
//  Copyright (c) 2012 steria. All rights reserved.
//
// Logic replicated from:    https://github.com/steria/swhrs-app/blob/master/js/util.js

#import "LoginCredentialFactory.h"
#import "EncodingUtility.h"
#import <RestKit/RestKit.h>

@interface LoginCredentialFactory()<RandomGenerator>
@end

@implementation LoginCredentialFactory
@synthesize randomGenerator = _randomGenerator;

-(NSString *) randomStringWithBase64Characters
{
    NSString *alphabet = [EncodingUtility base64EncodingTable];
    int stringLength = 8;
    NSMutableString *randomString = [[NSMutableString alloc] init];
    for (int i = 0; i < stringLength; i++)
    {
        int index = [self.randomGenerator getRandomNumber] % alphabet.length;
        unichar character = [alphabet characterAtIndex:index];
        [randomString appendString:[NSString stringWithCharacters:&character length:1]];
    }
    return randomString.copy;
}

-(NSString *) saltAndHash:(NSString *)password
{
    NSString *salt = [self randomStringWithBase64Characters];
    NSString *beforeHash = [NSString stringWithFormat:@"%@_%@", salt, password];
    NSString *sha1 = [EncodingUtility sha1:beforeHash];
    NSString *base64 = [EncodingUtility base64EncodeString:sha1];
    NSString *result = [NSString stringWithFormat:@"%@_%@", salt, base64];
    return result;
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
