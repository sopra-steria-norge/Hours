//
//  LoginCredentialFactory.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/28/12.
//  Copyright (c) 2012 steria. All rights reserved.
//
// SHA1 hash algorithm from: http://www.makebetterthings.com/iphone/how-to-get-md5-and-sha1-in-objective-c-ios-sdk/
// Base64 encoder from:      http://ios-dev-blog.com/base64-encodingdecoding/
// Logic replicated from:    https://github.com/steria/swhrs-app/blob/master/js/util.js

#import "LoginCredentialFactory.h"
#import <CommonCrypto/CommonDigest.h>

@interface LoginCredentialFactory()<RandomGenerator>
@end

@implementation LoginCredentialFactory
@synthesize randomGenerator = _randomGenerator;



NSString * const base64Alphabet =           @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="; // From swhrs-app, util.js
static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

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

-(NSString *) saltAndHash:(NSString *)password
{
    NSString *salt = [self randomBase64String];
    NSString *beforeHash = [NSString stringWithFormat:@"%@_%@", salt, password];
    NSString *sha1 = [self sha1:beforeHash];
    NSString *base64 = [self base64EncodeString:sha1];
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

-(NSString*) sha1:(NSString*)input
{ 
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString *) base64EncodeString: (NSString *) strData {
	return [self base64EncodeData: [strData dataUsingEncoding: NSUTF8StringEncoding] ];
}

- (NSString *) base64EncodeData: (NSData *) objData {
	const unsigned char * objRawData = [objData bytes];
	char * objPointer;
	char * strResult;
    
	// Get the Raw Data length and ensure we actually have data
	int intLength = [objData length];
	if (intLength == 0) return nil;
    
	// Setup the String-based Result placeholder and pointer within that placeholder
	strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
	objPointer = strResult;
    
	// Iterate through everything
	while (intLength > 2) { // keep going until we have less than 24 bits
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
		*objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
		*objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
		// we just handled 3 octets (24 bits) of data
		objRawData += 3;
		intLength -= 3;
	}
    
	// now deal with the tail end of things
	if (intLength != 0) {
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		if (intLength > 1) {
			*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
			*objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
			*objPointer++ = '=';
		} else {
			*objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
			*objPointer++ = '=';
			*objPointer++ = '=';
		}
	}
    
	// Terminate the string-based result
	*objPointer = '\0';
    
	// Return the results as an NSString object
	return [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
}

@end
