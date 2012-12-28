//
//  LoginViewController.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/9/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginState.h"
#import "MBHudHelper.h"
#import "Alert.h"

@interface LoginViewController () <LoginStateReceiver, MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) MBProgressHUD *hud;
- (IBAction)logIn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *errorText;
@end

@implementation LoginViewController

@synthesize userName = _userName;
@synthesize password = _password;
@synthesize hud = _hud;

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

- (void)viewDidAppear:(BOOL)animated
{
    bool isLoggedIn = [self checkStoredLogin];
    
    if(isLoggedIn)
    {
        [self performSegueWithIdentifier:@"LoggedInSegue" sender:self];
    }
}

- (void)didReceiveLoginState:(LoginState *) loginState
{
    [MBHudHelper HideSpinnerForHud:self.hud];
    self.hud = nil;
    
    [self hideLoginScreen];
}

- (void)didFailLoggingInWithError:(NSError *)error
{
    [self killHud];
    [[Alert createAlertWithTitle:NSLocalizedString(@"LOGINFAILEDHEADER", nil)
            andMessage:[NSString stringWithFormat:NSLocalizedString(@"LOGINFAILEDMESSAGEWITHFORMAT", nil),
            error.domain]]
     show];
}

- (void)killHud
{
    [MBHudHelper HideSpinnerForHud:self.hud];
    self.hud = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserName:nil];
    [self setPassword:nil];
    [self setErrorText:nil];
    [super viewDidUnload];
}

- (IBAction)logIn:(id)sender
{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    
    LoginState *loginState = [LoginState loginWithUserName:self.userName.text andPassword:self.password.text forReceiver:self];
    self.password.text = @""; // clean after login
    if(loginState)
    {
        [self hideLoginScreen];
    }
    else
    {
        self.hud = [MBHudHelper ShowSpinnerForDelegate:self withView:self.view];
    }
}

-(void) hideLoginScreen
{
    [self performSegueWithIdentifier:@"LoggedInSegue" sender:self];
}

-(bool) checkStoredLogin
{
    return self.loginState != nil;
}
@end
