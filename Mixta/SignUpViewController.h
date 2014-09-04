//
//  SignUpViewController.h
//  Mixta
//
//  Created by kai don aldag on 2014-09-02.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController

@property (strong, nonatomic)NSString *username;
@property (strong, nonatomic)NSString *password;
@property (strong, nonatomic)NSString *email;

@property (strong, nonatomic) PFFile *profilePicture;

@end
