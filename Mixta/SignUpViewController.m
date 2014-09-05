//
//  SignUpViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-02.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "Constents.h"
#import "SignUpViewController.h"
#import "SignInViewController.h"
#import "IntroViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface SignUpViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation SignUpViewController{
    UITextField *userNameField;
    UITextField *passwordField;
    UITextField *emailField;
    UIImageView *profilePictureField;
    
    UIButton *signUp;
    UIButton *signIn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    profilePictureField = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - 50, 350, 100, 100)];
    profilePictureField.image = [UIImage imageNamed:@"cameraIcon.png"];
    profilePictureField.layer.cornerRadius = 10;
    profilePictureField.layer.masksToBounds = YES;
    UITapGestureRecognizer *selectImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage)];
    [profilePictureField addGestureRecognizer:selectImage];
    profilePictureField.backgroundColor = [UIColor whiteColor];
    profilePictureField.userInteractionEnabled = YES;
    
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
    [self.view addSubview:profilePictureField];
    [self.view addSubview:signIn];
    [self.view addSubview:signUp];
    [self.view addSubview:emailLabel];
    [self.view addSubview:emailField];
    [self.view addSubview:passwordLabel];
    [self.view addSubview:passwordField];
    [self.view addSubview:userNameLabel];
    [self.view addSubview:userNameField];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SignUpBackGround.png"]];
}

-(void)resignKeyboards{
    [userNameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [emailField resignFirstResponder];
}

-(void)selectImage{
    NSLog(@"select image");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *imageSheet = [[UIActionSheet alloc]initWithTitle:@"Pick an image source"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"Take a photo", @"Choose an existing photo", nil];
        [imageSheet showInView:self.view];
    }else{
        UIActionSheet *imageSheet = [[UIActionSheet alloc]initWithTitle:@"Pick an image source"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"Choose an existing photo", nil];
        [imageSheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    if ([buttonTitle isEqualToString:@"Take a photo"]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if ([buttonTitle isEqualToString:@"Choose an existing photo"]){
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!img) img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *profilePictureData = [NSData dataWithData:UIImagePNGRepresentation(img)];
    
    self.profilePicture = [PFFile fileWithData:profilePictureData];
    
    profilePictureField.image = img;
}

-(void)createUser{
    NSLog(@"Sign up");
    
    self.email = [emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.username = [userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.password = [passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"Signing up, please wait";
    [hud show:YES];
    
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
        
        [hud hide:YES];
    }else if (self.password.length < 5){
        UIAlertView *noPassWord =[[UIAlertView alloc]initWithTitle:@"Oh no"
                                                           message:@"It appears your password is too small or isn't there"
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil];
        [noPassWord show];
        
        [hud hide:YES];
    }else if (isValidEmail == YES){
        UIAlertView *invalidEmail = [[UIAlertView alloc]initWithTitle:@"Oh no"
                                                              message:@"It appears you have an invalid email"
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"OK", nil];
        [invalidEmail show];
        
        [hud hide:YES];
    }else{
        signUp.hidden = YES;
        
        PFUser *user = [PFUser user];
        user.username = self.username;
        user.password = self.password;
        user.email = self.email;
        
        if (self.profilePicture) {
            [user setObject:self.profilePicture forKey:kProfilePictureKey];
        }else{
            UIImage *defaultProfileImage = [UIImage imageNamed:@"profile7.png"];
            NSData *data = [NSData dataWithData:UIImagePNGRepresentation(defaultProfileImage)];
            self.profilePicture = [PFFile fileWithData:data];
            [user setObject:self.profilePicture forKey:kProfilePictureKey];
        }
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                NSLog(@"OH NO AN ERROR SIGNING UP!!! description: %@", [error description]);
                UIAlertView *errorSigningUp = [[UIAlertView alloc]initWithTitle:@"An error occured"
                                                                        message:@"an error occured while signing up your account :( please try again, it might becuase you used a taken email, or taken username"
                                                                       delegate:nil
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"OK", nil];
                [errorSigningUp show];
                
                [hud hide:YES];
            }else{
                NSLog(@"Sign up successful");
                IntroViewController *introPage = [[IntroViewController alloc]init];
                [self presentViewController:introPage animated:YES completion:nil];
                
                [hud hide:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
