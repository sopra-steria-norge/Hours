//
// Created by tommywendelborg on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "LoginCredentialFactory.h"


@interface RandomGeneratorFake : NSObject <RandomGenerator>
-(id)initWithFixedBaseStringAlphaAtIndex:(int) result;
-(int)getRandomNumber;
@end