//
//  RegistrationAddViewController.h
//  Hours
//
//  Created by Tommy Wendelborg on 11/18/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppState.h"

@interface RegistrationAddViewController : UIViewController
@property (nonatomic, readonly, strong) AppState *state;
@property (nonatomic, readonly, strong) Registration *registration;
-(void) setState:(AppState *)state andRegistration:(Registration *) registration;
@end
