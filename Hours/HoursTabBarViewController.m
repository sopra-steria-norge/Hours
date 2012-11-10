//
//  HoursTabBarViewController.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/9/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "HoursTabBarViewController.h"

@interface HoursTabBarViewController ()
@property (nonatomic, strong) UITabBarItem* currentItem;
@end

@implementation HoursTabBarViewController
@synthesize currentItem = _currentItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
