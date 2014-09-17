//
//  TabBarViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-10.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "TabBarViewController.h"
#import "MusicSearchViewController.h"
#import "SidePanelViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        MusicSearchViewController *musicViewCon = [[MusicSearchViewController alloc]init];
        UINavigationController *musicNavCon = [[UINavigationController alloc]initWithRootViewController:musicViewCon];
        SidePanelViewController *panelCon = [[SidePanelViewController alloc]init];
        UINavigationController *panelNavCon = [[UINavigationController alloc]initWithRootViewController:panelCon];
        [panelNavCon setNavigationBarHidden:YES];
        
        self = [[UITabBarController alloc]init];
        self.viewControllers = @[panelNavCon, musicNavCon];
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
