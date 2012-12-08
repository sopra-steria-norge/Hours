//
//  LoginViewController.m
//  Hours
//
//  Created by Tommy Wendelborg on 11/9/12.
//  Copyright (c) 2012 steria. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginState.h"

@interface LoginViewController () <LoginStateReceiver>
@property(nonatomic, strong) LoginState *loginState;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)logIn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *errorText;
@end

@implementation LoginViewController
@synthesize userName = _userName;
@synthesize password = _password;
@synthesize loginState = _loginState;

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
    // TODO: Stop progress thingy
    self.loginState = loginState;
    [self hideLoginScreen];
}

- (void)didFailLoggingInWithError:(NSError *)error
{
    // TODO: Show error message
    // TODO: Stop progress thingy
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
    self.loginState = [LoginState loginWithUserName:self.userName.text andPassword:self.password.text forReceiver:self];
    self.password.text = @""; // clean after login
    if(self.loginState)
    {
        [self hideLoginScreen];
    }
    else
    {
        // TODO: Start progress thingy
    }

}

-(void) hideLoginScreen
{
    [self performSegueWithIdentifier:@"LoggedInSegue" sender:self];
}

-(bool) checkStoredLogin
{
    // TODO: 
    return self.loginState != nil;
}
@end
