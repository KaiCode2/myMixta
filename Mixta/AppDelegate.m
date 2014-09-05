//
//  AppDelegate.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-02.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "AppDelegate.h"
#import "SignInViewController.h"
#import "NewsFeedViewController.h"
#import "ProfileViewController.h"
#import "FindFriendsViewController.h"
#import <Parse/Parse.h>
#import <RESideMenu/RESideMenu.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [Parse setApplicationId:@"X3ZdLeraoNjySo0k7AdcNPAASrukyNpylFHXsAax"
                  clientKey:@"EaHUjTKDA4LNvF63Cz9eRQitl8b3YjZAZtjm02VA"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    NewsFeedViewController *homeViewCon = [[NewsFeedViewController alloc]init];
    SignInViewController *signUpViewController = [[SignInViewController alloc]init];
    ProfileViewController *profileViewCon = [[ProfileViewController alloc]init];
    FindFriendsViewController *friendsViewCon = [[FindFriendsViewController alloc]init];
    UINavigationController *newsNavCon = [[UINavigationController alloc]initWithRootViewController:homeViewCon];
    UINavigationController *profileNavCon = [[UINavigationController alloc]initWithRootViewController:profileViewCon];
    UINavigationController *friendsNavCon = [[UINavigationController alloc]initWithRootViewController:friendsViewCon];
    
    self.tabCon = [[UITabBarController alloc]init];
    self.tabCon.viewControllers = @[newsNavCon, friendsNavCon, profileNavCon];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    
    if ([PFUser currentUser]) {
        self.window.rootViewController = self.tabCon;
    }else{
        self.window.rootViewController = signUpViewController;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
