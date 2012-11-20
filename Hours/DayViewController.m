//
//  DayViewController.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "DayViewController.h"
#import "DataFactory.h"
#import "AppState.h"
#import "RegistrationAddViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

NSString * const WEEKDAY_DATE_FORMAT = @"EEEE";

@interface DayViewController () <AppStateReceiver, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

// Formatters
@property (nonatomic, readonly, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, readonly, strong) NSDateFormatter *dayFormatter;

// UI Controllers
@property (weak, nonatomic) IBOutlet UITableView *tblRegistrations;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDayName;
- (IBAction)btnNext:(id)sender;
- (IBAction)btnBack:(id)sender;

// Data fetching
@property (strong, nonatomic) DataFactory *dataFactory;
@end

@implementation DayViewController

@synthesize state = _state;
@synthesize dataFactory = _dataFactory;
@synthesize dateFormatter = _dateFormatter;
@synthesize dayFormatter = _dayFormatter;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.dataFactory = [[DataFactory alloc] init];
}

-(void)setState:(AppState *)state
{
    _state = state;
    
    NSString *title;
    if(state)
    {
        title = [self getDescriptionFromState:state];
    }
    else
    {
        title = @"...";
    }
    self.btnTitle.title = title;
    
    [self.tblRegistrations reloadData];
}

- (NSString *)getDescriptionFromState:(AppState *)state
{
    NSString *temp = [self.dateFormatter stringFromDate:state.currentDate];
    NSString *temp2 = [self.dayFormatter stringFromDate:state.currentDate];    
    NSString *title = [[NSString alloc] initWithFormat:@"%@ %@", temp2, temp, nil];
    return title;
}

-(NSDateFormatter *) dateFormatter
{
    if(!_dateFormatter)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        _dateFormatter = formatter;
    }
    
    return _dateFormatter;
}

-(NSDateFormatter *) dayFormatter
{
    if(!_dayFormatter)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:WEEKDAY_DATE_FORMAT];
        _dayFormatter = formatter;
    }
    
    return _dayFormatter;
}


- (void) viewWillAppear:(BOOL)animated
{
    AppState *state = [AppState deserializeOrLoadForReceiver:self];
    if(state)
    {
        self.state = state;
    }
    else
    {
        [self ShowSpinner];
    }
}

- (void)didReceiveAppState:(AppState*) state
{
    // For testing's sake, set the date to a date in the returned data
    state.currentDate = [[state.week.days objectAtIndex:0] date];
    
    self.state = state;
    
    NSLog(@"Did receive data from the loader");
    [HUD show:NO];
    [HUD removeFromSuperview];
}

- (void) didFailLoadingAppStateWithError:(NSError *)error
{
    [self HideSpinner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.state)
    {
        Day *currentDay = self.state.currentDay;
        return currentDay.registrations.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(self.state)
    {
        Day *currentDay = self.state.currentDay;
        if(indexPath.row >= currentDay.registrations.count)
        {
            cell = [self getCell:tableView forIndexPath:indexPath withCellIdentifier:@"AddRegistrationCell"];
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"add more...";
        }
        else
        {
            cell = [self getCell:tableView forIndexPath:indexPath withCellIdentifier:@"DayCellStyle"];
            Registration *r = [currentDay.registrations objectAtIndex:indexPath.row];
        
            Project *p = [self.state getProjectByNumber:r.projectNumber];
            cell.textLabel.text = p.projectName;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f", r.hours];
        }
    }
    else
    {
        cell = [self getCell:tableView forIndexPath:indexPath withCellIdentifier:@"DayCellStyle"];
        cell.textLabel.text = @"no data";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (UITableViewCell *)getCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath withCellIdentifier:(NSString *)cellIdentifier {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ModifyRegistrationSegue"])
    {
        NSIndexPath *selectedRowIndex = [self.tblRegistrations indexPathForSelectedRow];
        RegistrationAddViewController *rvc = [segue destinationViewController];
        rvc.state = self.state;

        Registration *r = [[self.state.currentDay registrations] objectAtIndex:selectedRowIndex.row];
        rvc.selectedHours = r.hours;
        rvc.selectedProject = r.projectNumber;
    }

}

- (void)ShowSpinner {
    HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
    [self.tabBarController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
}

- (void)HideSpinner {
    [HUD show:NO];
    [HUD removeFromSuperview];
}

- (IBAction)btnNext:(id)sender
{
    self.state = [self.state nextDay];
}

- (IBAction)btnBack:(id)sender
{
    self.state = [self.state previousDay];
}

- (void)viewDidUnload {
    [self setTblRegistrations:nil];
    [self setBtnDayName:nil];
    [self setBtnTitle:nil];
    [super viewDidUnload];
}

@end
