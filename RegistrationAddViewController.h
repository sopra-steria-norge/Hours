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
@property (nonatomic, strong) AppState *state;
@property (nonatomic, strong) NSString *selectedProject;
@property (nonatomic) double selectedHours;
@end
