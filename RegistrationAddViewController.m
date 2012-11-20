//
//  RegistrationAddViewController.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/18/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "RegistrationAddViewController.h"
#import "Project.h"

@interface RegistrationAddViewController ()<UIPickerViewDelegate, UIPickerViewDataSource> 
@property (nonatomic, strong) NSString *project;
@property (nonatomic) double hours;
@property (nonatomic, strong) NSArray *projectValues;
@property (nonatomic, strong) NSArray *hourValues;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerHours;
@property (weak, nonatomic) IBOutlet UIButton *buttonOk;
- (IBAction)buttonOkClicked:(id)sender;
@end

@implementation RegistrationAddViewController

@synthesize project = _project;
@synthesize hours = _hours;

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
    self.projectValues = [[NSArray alloc] initWithObjects:@"none", nil];
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
    [self setPickerHours:nil];
    [self setHourValues:nil];
    [self setButtonOk:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0)
    {
        return [self.projectValues count];
    }
    return [self.hourValues count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (component == 0)
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

+(NSArray *)getHourValues
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(int cnt = 0; cnt <= 48; cnt++)
    {
        [temp addObject:[NSNumber numberWithDouble:0.5 * cnt]];
    }
    return temp.copy;
}

- (IBAction)buttonOkClicked:(id)sender {
}
@end
