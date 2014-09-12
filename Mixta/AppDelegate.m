//
//  AppDelegate.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-02.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "AppDelegate.h"
#import "SignInViewController.h"
#import "TabBarViewController.h"
#import <Parse/Parse.h>
#import <RESideMenu/RESideMenu.h>
#import <AVFoundation/AVFoundation.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [Parse setApplicationId:@"X3ZdLeraoNjySo0k7AdcNPAASrukyNpylFHXsAax"
                  clientKey:@"EaHUjTKDA4LNvF63Cz9eRQitl8b3YjZAZtjm02VA"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    SignInViewController *signUpViewController = [[SignInViewController alloc]init];
    TabBarViewController *tabCon = [[TabBarViewController alloc]init];
    
    if ([PFUser currentUser]) {
        self.window.rootViewController = tabCon;
    }else{
        self.window.rootViewController = signUpViewController;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
