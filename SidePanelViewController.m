//
//  SidePanelControllerViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-16.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "SidePanelViewController.h"
#import "NewsFeedViewController.h"
#import "LeftSidePanelContentViewController.h"

@interface SidePanelViewController ()
@end

@implementation SidePanelViewController

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
    UINavigationController *leftNavCon = [[UINavigationController alloc]initWithRootViewController:[[LeftSidePanelContentViewController alloc]init]];
    [leftNavCon setNavigationBarHidden:YES];
    self.leftPanel = leftNavCon;
    self.centerPanel = [[UINavigationController alloc]initWithRootViewController:[[NewsFeedViewController alloc]init]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITabBarItem*)tabBarItem{
    //TODO: move to init
    UITabBarItem* tabbar = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"letter28.png"] tag:0];
    [tabbar setImageInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    return tabbar;
}

@end
