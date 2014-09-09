//
//  SignInViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-02.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "SignInViewController.h"
#import "NewsFeedViewController.h"
#import "SignUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface SignInViewController ()

@end

@implementation SignInViewController{
    UITextField *userNameField;
    UITextField *passwordField;
    
    UIButton *signIn;
    UIButton *signUp;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    signIn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100)];
    [signIn addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
    signIn.backgroundColor = [UIColor colorWithRed:0 green:0.25 blue:0.75 alpha:0.45];
    [signIn setTitle:@"Sign in" forState:UIControlStateNormal];
    
    signUp = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 60)];
    [signUp addTarget:self action:@selector(presentSignUp) forControlEvents:UIControlEventTouchUpInside];
    signUp.backgroundColor = [UIColor colorWithRed:0 green:0.25 blue:0.75 alpha:0.45];
    [signUp setTitle:@"Sign Up!" forState:UIControlStateNormal];
    
    UITapGestureRecognizer *resignKeyboards = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboards)];
    [self.view addGestureRecognizer:resignKeyboards];
    [self.view addSubview:signUp];
    [self.view addSubview:signIn];
    [self.view addSubview:passwordField];
    [self.view addSubview:passwordLabel];
    [self.view addSubview:userNameField];
    [self.view addSubview:userNameLabel];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SignUpBackGround.png"]];
}

-(void)resignKeyboards{
    [userNameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

-(void)signIn{
    NSLog(@"sign in");
    signIn.userInteractionEnabled = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"Signing up, please wait";
    [hud show:YES];
    
    self.username = [userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.password = [passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (self.username.length < 3) {
        UIAlertView *invalidUserName = [[UIAlertView alloc]initWithTitle:@"Oh no"
                                                                 message:@"The user name you entered is invalid"
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"OK", nil];
        [invalidUserName show];
        
        [hud hide:YES];
        signIn.userInteractionEnabled = YES;
    }else if (self.password.length < 5){
        UIAlertView *invalidPassword = [[UIAlertView alloc]initWithTitle:@"Oh no"
                                                                 message:@"The password you entered is invalid"
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"OK", nil];
        [invalidPassword show];
        
        [hud hide:YES];
        signIn.userInteractionEnabled = YES;
    }else{
        [PFUser logInWithUsernameInBackground:self.username password:self.password block:^(PFUser *user, NSError *error) {
            if (error) {
                NSLog(@"error loging in with description %@", error.description);
                UIAlertView *loginError = [[UIAlertView alloc]initWithTitle:@"Oh no"
                                                                    message:@"An error occured while logging you in, please try again"
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [loginError show];
                
                [hud hide:YES];
                signIn.userInteractionEnabled = YES;
            }else{
                NSLog(@"Loging successful");
                NewsFeedViewController *homeViewCon = [[NewsFeedViewController alloc]init];
                [self presentViewController:homeViewCon animated:YES completion:nil];
                
                [hud hide:YES];
                signIn.userInteractionEnabled = YES;
            }
        }];
    }
}

-(void)presentSignUp{
    SignUpViewController *nextViewCon = [[SignUpViewController alloc]init];
    [self presentViewController:nextViewCon animated:YES completion:nil];
}

@end
