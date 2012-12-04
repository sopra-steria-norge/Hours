//
// Created by tommywendelborg on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RandomGeneratorFake.h"


@implementation RandomGeneratorFake

@synthesize numberToReturn = _numberToReturn;

-(int)getRandomNumber
{
    return self.numberToReturn;
}

@end