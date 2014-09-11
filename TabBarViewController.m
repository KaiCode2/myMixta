//
//  TabBarViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-10.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "TabBarViewController.h"
#import "NewsFeedViewController.h"
#import "ProfileViewController.h"
#import "FindFriendsViewController.h"
#import "MusicSearchViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NewsFeedViewController *homeViewCon = [[NewsFeedViewController alloc]init];
        ProfileViewController *profileViewCon = [[ProfileViewController alloc]init];
        FindFriendsViewController *friendsViewCon = [[FindFriendsViewController alloc]init];
        UINavigationController *newsNavCon = [[UINavigationController alloc]initWithRootViewController:homeViewCon];
        UINavigationController *profileNavCon = [[UINavigationController alloc]initWithRootViewController:profileViewCon];
        UINavigationController *friendsNavCon = [[UINavigationController alloc]initWithRootViewController:friendsViewCon];
        MusicSearchViewController *viewCon = [[MusicSearchViewController alloc]init];
        
        self = [[UITabBarController alloc]init];
        self.viewControllers = @[newsNavCon, friendsNavCon, profileNavCon, viewCon];
        [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
