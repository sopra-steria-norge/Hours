//
//  RegistrationAddViewController.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/18/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "RegistrationAddViewController.h"

@interface RegistrationAddViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) AppState *state;
@property (nonatomic, strong) Registration *registration;

@property (nonatomic, strong) NSArray *projectValues;
@property (nonatomic, readonly, strong) NSArray *hourValues;
@property (weak, nonatomic) IBOutlet UIButton *buttonOk;
@property (weak, nonatomic) IBOutlet UILabel *labelErrorText;
@property (weak, nonatomic) IBOutlet UIPickerView *projectPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *hourPickerView;
- (IBAction)buttonOkClicked:(id)sender;
- (IBAction)buttonSevenPointFive:(id)sender;
- (IBAction)buttonZeroPointFive:(id)sender;
@end

@implementation RegistrationAddViewController

@synthesize state = _state;
@synthesize registration = _registration;

@synthesize hourValues = _hourValues;
@synthesize projectValues = _projectValues;

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
    self.buttonOk.enabled = NO; // TODO: Enable when a project is selected

    if(!self.projectValues)
    {
        self.projectValues = [[NSArray alloc] initWithObjects:@"none", nil];   
    }
}

- (NSArray *)hourValues
{
    if(!_hourValues)
    {
        _hourValues = [RegistrationAddViewController getHourValues];
    }
    return _hourValues;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCancel:(id)sender
{
    [self dismissModalViewControllerAnimated: YES];
}
- (void)viewDidUnload
{
    _hourValues = nil;
    [self setButtonOk:nil];
    [self setProjectPickerView:nil];
    [self setHourPickerView:nil];
    [self setLabelErrorText:nil];
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated
{
    if(!self.registration)
    {
        self.registration = [[Registration alloc] init];
    }
    [self setHourPickerToRegistrationHours];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == self.projectPickerView)
    {
        return [self.projectValues count];
    }
    return [self.hourValues count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.projectPickerView)
    {
        id myRow = [self.projectValues objectAtIndex:row];
        if([myRow isKindOfClass:[Project class]])
        {
            Project *p = (Project *)myRow;
            return p.description;
        }
        return [self.projectValues objectAtIndex:row];
    }
    
    NSNumber *number = (NSNumber *)[self.hourValues objectAtIndex:row];
    return [number stringValue];
}

-(void) setState:(AppState *)state andRegistration:(Registration *) registration
{
    self.state = state;
    self.registration = registration;
 
    NSMutableArray *projects;

    if(registration)
    {
        projects = [[NSMutableArray alloc] init];
        for(Project *p in self.state.week.projects)
        {
            if([p.projectNumber isEqualToString:registration.projectNumber])
            {
                [projects addObject:p];
                break;
            }
        }
    }
    else
    {
        projects = state.week.projects;
    }
    _projectValues = projects.copy; // TODO: Remove existing?
}

+(NSArray *)getHourValues
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(int cnt = 0; cnt <= 48; cnt++)
    {
        [temp addObject:[NSNumber numberWithDouble:0.5 * cnt]];
    }
    return temp.copy;
}

- (IBAction)buttonOkClicked:(id)sender
{
    
}
- (IBAction)buttonSevenPointFive:(id)sender
{
    self.registration.hours = 7.5;
    [self setHourPickerToRegistrationHours];
}

- (IBAction)buttonZeroPointFive:(id)sender
{
    self.registration.hours = 0.5;
    [self setHourPickerToRegistrationHours];
}

- (void) setHourPickerToRegistrationHours
{
    if(self.registration)
    {
        int row = (int)(self.registration.hours / 0.5);
        [self.hourPickerView selectRow:row inComponent:0 animated:YES];
    }
}
@end
