//
//  LoginCredentialFactory.h
//  Hours
//
//  Created by Tommy Wendelborg on 11/28/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginCredentialFactory : NSObject
-(NSString *) saltAndHash:(NSString *)password;
@end
