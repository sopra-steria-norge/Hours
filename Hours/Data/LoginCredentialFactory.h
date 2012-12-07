//
//  LoginCredentialFactory.h
//  Hours
//
//  Created by Tommy Wendelborg on 11/28/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RandomGenerator <NSObject>
- (int) getRandomNumber;
@end

@interface LoginCredentialFactory : NSObject
@property (nonatomic, strong) id<RandomGenerator> randomGenerator;
-(NSString *) saltAndHash:(NSString *)password;
-(NSString *) randomStringWithBase64Characters;
@end
