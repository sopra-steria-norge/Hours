//
//  EncodingUtility.h
//  Hours
//
//  Created by Tommy Wendelborg on 12/7/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncodingUtility : NSObject

+ (NSData*) sha1:(NSString*)input;
+ (NSString *) base64EncodingTable;
+ (NSString *) base64EncodeData: (NSData *) data;

@end
