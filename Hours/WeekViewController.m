//
//  WeekViewController.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/4/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "WeekViewController.h"
#import "DataFactory.h"

@interface WeekViewController () <AppStateReceiver, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UITableView *tableDays;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonSubmit;

- (IBAction)buttonPrevious:(id)sender;
- (IBAction)buttonNext:(id)sender;

// Data fetching
@property (strong, nonatomic) DataFactory *dataFactory;
@end

@implementation WeekViewController
@synthesize state = _state;

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
    AppState *state = [AppState deserializeOrLoadForReceiver:self];
    if(state)
    {
        self.state = state;
        
        if(self.state.registrationsToSave.count > 0)
        {
            // TODO: Send to server, refetch period afterwards!
        }
    }
    else
    {
        [self ShowSpinner];
    }
    [self setupSwipe];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    [HUD show:NO];
    [HUD removeFromSuperview];
}

- (void) didFailLoadingAppStateWithError:(NSError *)error
{
    [self HideSpinner];
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
    
    self.tabBarController.selectedIndex = 0; // TODO: Make type based in stead of index based
}

- (void)setupSwipe
{
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(buttonNext:)];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.tableDays addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(buttonPrevious:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableDays addGestureRecognizer:oneFingerSwipeRight];
}


- (void)ShowSpinner // TODO: Centralize
{
    HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
    [self.tabBarController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
}

- (void)HideSpinner // TODO: Centralize
{
    [HUD show:NO];
    [HUD removeFromSuperview];
}

- (void)viewDidUnload {
    [self setTableDays:nil];
    [self setButtonTitle:nil];
    [self setButtonSubmit:nil];
    [self setButtonSubmit:nil];
    [super viewDidUnload];
}

- (IBAction)buttonPrevious:(id)sender
{
    [self.state navigatePreviousWeek];
    self.state = [AppState deserializeOrLoadForReceiver:self]; // TODO: Move deserialization out of view controllers
}

- (IBAction)buttonNext:(id)sender
{
    [self.state navigateNextWeek];
    self.state = [AppState deserializeOrLoadForReceiver:self]; // TODO: Move deserialization out of view controllers 
}
@end
