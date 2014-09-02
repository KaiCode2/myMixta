//
//  SignUpViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-02.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "SignUpViewController.h"
#import "NewsFeedViewController.h"
#import "SignInViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController{
    UITextField *userNameField;
    UITextField *passwordField;
    UITextField *emailField;
    
    UIButton *signUp;
    UIButton *signIn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIAlertView *welcomeAlert = [[UIAlertView alloc]initWithTitle:@"Welcome to Mixta"
                                                          message:@"Welcome to Mixta please sign up for an account"
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"OK", nil];
    [welcomeAlert show];
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 25, 50, 100, 50)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.text = @"Username";
    userNameField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.center.x - 125, 100, 250, 40)];
    userNameField.backgroundColor = [UIColor whiteColor];
    userNameField.textAlignment = NSTextAlignmentCenter;
    userNameField.layer.cornerRadius = 10;
    userNameField.layer.masksToBounds = YES;
    userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 25, 150, 100, 50)];
    passwordLabel.backgroundColor = [UIColor clearColor];
    passwordLabel.text = @"Password";
    passwordField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.center.x - 125, 200, 250, 40)];
    passwordField.backgroundColor = [UIColor whiteColor];
    passwordField.textAlignment = NSTextAlignmentCenter;
    [passwordField setSecureTextEntry:YES];
    passwordField.layer.cornerRadius = 10;
    passwordField.layer.masksToBounds = YES;
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 25, 250, 100, 50)];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = @"Email";
    emailField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.center.x - 125, 300, 250, 40)];
    emailField.backgroundColor = [UIColor whiteColor];
    emailField.textAlignment = NSTextAlignmentCenter;
    emailField.layer.cornerRadius = 10;
    emailField.layer.masksToBounds = YES;
    emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    signUp = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100)];
    [signUp addTarget:self action:@selector(createUser) forControlEvents:UIControlEventTouchUpInside];
    signUp.backgroundColor = [UIColor colorWithRed:0 green:0.25 blue:0.75 alpha:0.45];
    [signUp setTitle:@"Sign Up!" forState:UIControlStateNormal];
    
    signIn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 75, 0, 75, 60)];
    [signIn addTarget:self action:@selector(presentSignIn) forControlEvents:UIControlEventTouchUpInside];
    signIn.backgroundColor = [UIColor colorWithRed:0 green:0.25 blue:0.75 alpha:0.45];
    [signIn setTitle:@"Sign in" forState:UIControlStateNormal];
    
    UITapGestureRecognizer *resignKeyboards = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboards)];
    [self.view addGestureRecognizer:resignKeyboards];
    [self.view addSubview:signIn];
    [self.view addSubview:signUp];
    [self.view addSubview:emailLabel];
    [self.view addSubview:emailField];
    [self.view addSubview:passwordLabel];
    [self.view addSubview:passwordField];
    [self.view addSubview:userNameLabel];
    [self.view addSubview:userNameField];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SignUpBackgroundv2 2.png"]];
}

-(void)resignKeyboards{
    [userNameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [emailField resignFirstResponder];
}

-(void)createUser{
    NSLog(@"Sign up");
    
    self.email = [emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.username = [userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.password = [passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    BOOL isValidEmail = NO;
    if(self.email){
        isValidEmail = ![self NSStringIsValidEmail:self.email];
    }else{
        isValidEmail = YES;
    }
    
    if (self.username.length < 3) {
        UIAlertView *noUserName = [[UIAlertView alloc]initWithTitle:@"Oh no"
                                                            message:@"It appears your username is to small, or isn't there"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [noUserName show];
    }else if (self.password.length < 5){
        UIAlertView *noPassWord =[[UIAlertView alloc]initWithTitle:@"Oh no"
                                                           message:@"It appears your password is too small or isn't there"
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil];
        [noPassWord show];
    }else if (isValidEmail == YES){
        UIAlertView *invalidEmail = [[UIAlertView alloc]initWithTitle:@"Oh no"
                                                              message:@"It appears you have an invalid email"
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"OK", nil];
        [invalidEmail show];
    }else{
        PFUser *user = [PFUser user];
        user.username = self.username;
        user.password = self.password;
        user.email = self.email;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                NSLog(@"OH NO AN ERROR SIGNING UP!!!");
                UIAlertView *errorSigningUp = [[UIAlertView alloc]initWithTitle:@"An error occured"
                                                                        message:@"an error occured while signing up your account :( please try again"
                                                                       delegate:nil
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"OK", nil];
                [errorSigningUp show];
            }else{
                NSLog(@"Sign up successful");
                NewsFeedViewController *homeViewCon = [[NewsFeedViewController alloc]init];
                [self presentViewController:homeViewCon animated:YES completion:nil];
            }
        }];
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)presentSignIn{
    NSLog(@"sign in");
    SignInViewController *signInCon = [[SignInViewController alloc]init];
    [self presentViewController:signInCon animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
