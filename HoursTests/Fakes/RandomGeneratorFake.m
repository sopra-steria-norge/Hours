//
// Created by tommywendelborg on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RandomGeneratorFake.h"


@interface RandomGeneratorFake()
@property(nonatomic) int numberToReturn;
@end
@implementation RandomGeneratorFake

-(id)initWithFixedBaseStringAlphaAtIndex:(int) result
{
    self = [super init];
    if (self)
    {
        self.numberToReturn = result;
    }
    return self;
}

@synthesize numberToReturn = _numberToReturn;

-(int)getRandomNumber
{
    return self.numberToReturn;
}

@end