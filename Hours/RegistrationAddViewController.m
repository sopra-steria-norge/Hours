//
//  RegistrationAddViewController.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/18/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "RegistrationAddViewController.h"

@interface RegistrationAddViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *projectValues;
@property (nonatomic, strong) NSArray *hourValues;
@property (weak, nonatomic) IBOutlet UIButton *buttonOk;
@property (weak, nonatomic) IBOutlet UIPickerView *projectPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *hourPickerView;
- (IBAction)buttonOkClicked:(id)sender;
@end

@implementation RegistrationAddViewController

@synthesize state = _state;
@synthesize selectedProject = _selectedProject;
@synthesize selectedHours = _selectedHours;

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
    self.hourValues = [RegistrationAddViewController getHourValues];

    if(!self.projectValues)
    {
        self.projectValues = [[NSArray alloc] initWithObjects:@"none", nil];   
    }
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
- (void)viewDidUnload {
    [self setHourValues:nil];
    [self setButtonOk:nil];
    [self setProjectPickerView:nil];
    [self setHourPickerView:nil];
    [super viewDidUnload];
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

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
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

-(void)setState:(AppState *)state
{
    _state = state;
    _projectValues = state.week.projects.copy; // TODO: Only use projects that are not already set for the day
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
@end
