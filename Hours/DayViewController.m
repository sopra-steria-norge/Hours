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
#import <MBProgressHUD/MBProgressHUD.h>

@interface DayViewController () <AppStateReceiver, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITableView *tblRegistrations;
@property (strong, nonatomic) DataFactory *dataFactory;
@end

@implementation DayViewController
@synthesize state = _state;
@synthesize dataFactory = _dataFactory;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.dataFactory = [[DataFactory alloc] init];
}

-(void)setState:(AppState *)state
{
    _state = state;
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
    [self.tblRegistrations reloadData];
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
        return currentDay.registrations.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"DayCellStyle";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if(self.state)
    {
        Day *currentDay = self.state.currentDay;
        Registration *r = [currentDay.registrations objectAtIndex:indexPath.row];
        
        Project *p = [self.state getProjectByNumber:r.projectNumber];
        cell.textLabel.text = p.projectName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f", r.hours];

    }
    else
    {
        cell.textLabel.text = @"no data";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: 
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

- (void)viewDidUnload {
    [self setTblRegistrations:nil];
    [super viewDidUnload];
}
@end
