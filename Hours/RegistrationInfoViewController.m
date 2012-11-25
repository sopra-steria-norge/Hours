//
//  RegistrationInfoViewController.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/25/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "RegistrationInfoViewController.h"

@interface RegistrationInfoViewController ()
@property (nonatomic, strong) AppState *state;
@property (nonatomic, strong) Registration *registration;

- (IBAction)buttonOk:(id)sender;
@end

@implementation RegistrationInfoViewController

@synthesize state = _state;
@synthesize registration = _registration;

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

-(void) setState:(AppState *)state andRegistration:(Registration *) registration
{
    self.state = state;
    self.registration = registration;
}

- (IBAction)buttonOk:(id)sender
{
    [self dismissModalViewControllerAnimated: YES];
}
@end
