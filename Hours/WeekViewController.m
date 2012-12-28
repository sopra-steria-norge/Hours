//
//  WeekViewController.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "WeekViewController.h"
#import "MBHudHelper.h"
#import "Alert.h"
#import "DayViewController.h"

@interface WeekViewController () <AppStateReceiver, AppStateSubmitter, MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableDays;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonSubmit;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) UIAlertView *submitAlert;

- (IBAction)buttonPreviousClicked:(id)sender;
- (IBAction)buttonNextClicked:(id)sender;
- (IBAction)buttonSubmitClicked:(id)sender;
@end

@implementation WeekViewController
@synthesize state = _state;
@synthesize hud = _hud;
@synthesize submitAlert = _submitAlert;

-(void)setState:(AppState *)state
{
    _state = state;
    
    NSString *title;
    if(state)
    {
        title = self.state.currentWeek.description;
    }
    else
    {
        title = @"...";
    }
    self.buttonSubmit.enabled = ![self.state isLocked];
    
    self.buttonTitle.title = title;
    
    [self.tableDays reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    AppState *state = [AppState getOrLoadForReceiver:self];
    if(state)
    {
        self.state = state;
    }
    else
    {
        [MBHudHelper ShowSpinnerForDelegate:self withView:self.tabBarController.view];
    }
    [self setupSwipe];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.submitAlert = [Alert createOkCancelAlertWithTitle:NSLocalizedString(@"SUBMITHEADER", nil)
                                                andMessage:NSLocalizedString(@"SUBMITMESSAGE", nil)
                                               forDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveAppState:(AppState*) state
{   
    self.state = state;
    
    NSLog(@"Did receive data from the loader");
    [MBHudHelper HideSpinnerForHud:self.hud];
    self.hud = nil;
}

- (void) didFailLoadingAppStateWithError:(NSError *)error
{
    [MBHudHelper HideSpinnerForHud:self.hud];
        self.hud = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    if(self.state)
    {
        count = self.state.currentWeek.days.count;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"WeekViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Day *d = [self.state.currentWeek.days objectAtIndex:indexPath.row];
    cell.textLabel.text = [self.state getTitleForDate:d.date];
    NSString *details = [d getSummary];
    cell.detailTextLabel.text = details;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Day *d = [self.state.currentWeek.days objectAtIndex:indexPath.row];
    self.state.currentDate = d.date;
    
    int dayViewControllerIndex = 0;
    self.tabBarController.selectedIndex = dayViewControllerIndex;
}

- (void)setupSwipe
{
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(buttonNextClicked:)];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.tableDays addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(buttonPreviousClicked:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableDays addGestureRecognizer:oneFingerSwipeRight];
}

- (void)viewDidUnload {
    [self setTableDays:nil];
    [self setButtonTitle:nil];
    [self setButtonSubmit:nil];
    [self setButtonSubmit:nil];
    [self setHud:nil];
    [self setSubmitAlert:nil];
    [super viewDidUnload];
}

- (IBAction)buttonPreviousClicked:(id)sender
{
    [self.state navigatePreviousWeek];
    self.state = [AppState getOrLoadForReceiver:self];
}

- (IBAction)buttonNextClicked:(id)sender
{
    [self.state navigateNextWeek];
    self.state = [AppState getOrLoadForReceiver:self];
}

- (IBAction)buttonSubmitClicked:(id)sender
{
    [self.submitAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == self.submitAlert && buttonIndex == 0)
    {
        [[Alert createAlertWithTitle:@"// TODO: " andMessage:@"Submit the week"] show];
    }
}

- (void)logOut
{
    [AppState clear];
    UITabBarController *parent = (UITabBarController *)[self parentViewController];
    [parent dismissViewControllerAnimated:YES completion:nil];
}

@end
