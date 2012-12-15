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
#import "MBHudHelper.h"
#import "RegistrationAddViewController.h"
#import "RegistrationInfoViewController.h"
#import "Alert.h"

@interface DayViewController () <AppStateReceiver, MBProgressHUDDelegate>

// UI Controllers
@property (weak, nonatomic) IBOutlet UITableView *tblRegistrations;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonHeaderIcon;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDayName;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) UIAlertView *updateFailedAlert;
@property (strong, nonatomic) UIAlertView *loadFailedAlert;

// Data fetching
@property (strong, nonatomic) DataFactory *dataFactory;
@end

@implementation DayViewController

@synthesize state = _state;
@synthesize dataFactory = _dataFactory;
@synthesize hud = _hud;
@synthesize updateFailedAlert = _updateFailedAlert;
@synthesize loadFailedAlert = _loadFailedAlert;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupSwipe];
    
    self.dataFactory = [[DataFactory alloc] init];
    self.loadFailedAlert = [Alert createOkCancelAlertWithTitle:@"Loading failed" andMessage:@"Retry" forDelegate:self];
    self.updateFailedAlert = [Alert createOkCancelAlertWithTitle:@"Updating failed" andMessage:@"Retry?" forDelegate:self];
}

-(void)setState:(AppState *)state
{
    _state = state;
    
    NSString *title;
    if(state)
    {
        title = [state currentDayTitle];
    }
    else
    {
        title = @"";
    }
    self.btnTitle.title = title;
    
    self.buttonAdd.enabled = ![self.state isLocked];
    
    if([self.state isLocked])
    {
        self.buttonHeaderIcon.image = [UIImage imageNamed:@"lock.png"];
    }  
    
    [self.tblRegistrations reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.buttonAdd.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    
    [self updateState];
}

-(void)updateState
{
    AppState *state = [AppState getOrLoadForReceiver:self];
    if(state)
    {
        self.state = state;
        
        if(self.state.registrationsToSave.count > 0)
        {
            [[Alert createAlertWithTitle:@"// TODO: " andMessage:@"Supposed to send some data here..."] show];
        }
    }
    else
    {
        self.hud = [MBHudHelper ShowSpinnerForDelegate:self withView:self.tabBarController.view];
    }
}

- (void)didReceiveAppState:(AppState*) state
{
    NSLog(@"WARNING! for testing sake the current date is set to the first date of the loaded week");
    state.currentDate = [[state.currentWeek.days objectAtIndex:0] date]; // TODO: This is for testing
    
    self.state = state;
    
    NSLog(@"Did receive data from the loader");
    [MBHudHelper HideSpinnerForHud:self.hud];
    self.hud = nil;
    }

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == self.loadFailedAlert)
    {
        [[Alert createAlertWithTitle:@"// TODO: " andMessage:@"Handle failed load attempts, retry on OK, logout on CANCEL"] show];
    }
    else if(alertView == self.updateFailedAlert)
    {
        [[Alert createAlertWithTitle:@"// TODO: " andMessage:@"Handle failed update attempts, retry on OK, logout on CANCEL"] show];
    }
}

- (void) didFailLoadingAppStateWithError:(NSError *)error
{
    [MBHudHelper HideSpinnerForHud:self.hud];
    self.hud = nil;
    [self.loadFailedAlert show];
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
        if([self isCopyPreviousDayEnabled])
        {
            return 1;
        }
        else
        {
            return self.state.currentDay.registrations.count;
        }
    }
    return 0;
}

- (bool)isCopyPreviousDayEnabled
{
    if(self.state)
    {
        int count = self.state.currentDay.registrations.count;
        if(!self.state.currentWeek.isSubmitted && count == 0)
        {
            return YES;
        }
    }
    return NO;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	if([self isCopyPreviousDayEnabled])
    {
        [[Alert createAlertWithTitle:@"// TODO: " andMessage:@"Actually copy something..."] show];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(self.state)
    {
        if([self.state isLocked])
        {
            cell = [self getReadOnlyCell:tableView indexPath:indexPath];
        }
        else
        {
            cell = [self getEditableCell:tableView indexPath:indexPath];            
        }
    }
    else
    {
        cell = [self getCell:tableView forIndexPath:indexPath withCellIdentifier:@"EditDayCellStyle"];
        cell.textLabel.text = @"no data";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (UITableViewCell *)getEditableCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    Day *currentDay = self.state.currentDay;
    UITableViewCell *cell;
    
    if(indexPath.row >= currentDay.registrations.count)
            {
                cell = [self getCell:tableView forIndexPath:indexPath withCellIdentifier:@"CopyRegistrationsCell"];
                cell.textLabel.text = @"";
                cell.detailTextLabel.text = @"copy yesterday...";
            }
            else
            {
                cell = [self getCell:tableView forIndexPath:indexPath withCellIdentifier:@"ModifyDayCellStyle"];
                Registration *r = [currentDay.registrations objectAtIndex:indexPath.row];

                Project *p = [self.state getProjectByNumber:r.projectNumber andActivityCode:r.activityCode];
                cell.textLabel.text = p.projectName;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f", r.hours];
            }
    return cell;
}

- (UITableViewCell *)getReadOnlyCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    Day *currentDay = self.state.currentDay;
    UITableViewCell *cell = [self getCell:tableView forIndexPath:indexPath withCellIdentifier:@"ViewDayCellStyle"];
    Registration *r = [currentDay.registrations objectAtIndex:indexPath.row];

    Project *p = [self.state getProjectByNumber:r.projectNumber andActivityCode:r.activityCode];
    cell.textLabel.text = p.projectName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f", r.hours];

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
        Registration *r = [[self.state.currentDay registrations] objectAtIndex:selectedRowIndex.row];

        [rvc setState:self.state andRegistration:r];
    }
    else if([[segue identifier] isEqualToString:@"AddRegistrationSegue"])
    {
        RegistrationAddViewController *rvc = [segue destinationViewController];
        [rvc setState:self.state andRegistration:nil];
    }
    else
    {
        NSIndexPath *selectedRowIndex = [self.tblRegistrations indexPathForSelectedRow];
        RegistrationInfoViewController *rvc = [segue destinationViewController];
        Registration *r = [[self.state.currentDay registrations] objectAtIndex:selectedRowIndex.row];
        
        [rvc setState:self.state andRegistration:r];
    }
}

- (void)setupSwipe
{
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(btnNext:)];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.tblRegistrations addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(btnBack:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tblRegistrations addGestureRecognizer:oneFingerSwipeRight];
}

- (IBAction)btnNext:(id)sender
{
    self.state = [self.state navigateNextDay];
    
    if(!self.state.currentWeek)
    {
        [self updateState];
    }
}

- (IBAction)btnBack:(id)sender
{
    self.state = [self.state navigatePreviousDay];
    
    if(!self.state.currentWeek)
    {
        [self updateState];
    }
}

- (void)viewDidUnload {
    [self setTblRegistrations:nil];
    [self setBtnDayName:nil];
    [self setBtnTitle:nil];
    [self setButtonAdd:nil];
    [self setButtonHeaderIcon:nil];
    [self setHud:nil];
    [self setUpdateFailedAlert:nil];
    [self setLoadFailedAlert:nil];
    [super viewDidUnload];
}

@end
