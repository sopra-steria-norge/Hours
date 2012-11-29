//
//  LoginCredentialFactory.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/28/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "LoginCredentialFactory.h"

@implementation LoginCredentialFactory

-(NSString *) saltAndHash:(NSString *)password
{
    NSString *hashed = password.copy;
    return hashed;
}

@end
