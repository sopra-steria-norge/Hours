//
//  DayViewController.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "DayViewController.h"
#import "WeekReceiver.h"

@interface DayViewController () <WeekReceiver>

@end

@implementation DayViewController
@synthesize state = _state;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    self.state = [[AppState alloc] initWithDate:[[NSDate alloc] init]];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.state = [AppState deserializeOrLoadForReceiver:self];
}

-(void)didReceiveWeek:(Week*) week
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
