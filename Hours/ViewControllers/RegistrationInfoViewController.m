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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelActivityCode;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelHours;

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
    
    Project *projectForRegistration;
    for(Project *p in self.state.currentWeek.projects)
    {
        if(p.projectNumber == self.registration.projectNumber && p.activityCode == self.registration.activityCode)
        {
            projectForRegistration = p;
            break;
        }
    }
        
    self.buttonTitle.title = self.state.currentDayTitle;
    self.labelActivityCode.text = self.registration.activityCode;
    self.labelHours.text = [NSString stringWithFormat:NSLocalizedString(@"HOURSWITHFORMAT", nil), self.registration.hours];
    self.textViewDescription.text = projectForRegistration.description;
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
- (void)viewDidUnload {
    [self setButtonTitle:nil];
    [self setLabelActivityCode:nil];
    [self setTextViewDescription:nil];
    [self setLabelHours:nil];
    [super viewDidUnload];
}
@end
