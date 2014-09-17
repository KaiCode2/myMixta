//
//  LeftSidePanelContentViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-16.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//
#import "Constents.h"
#import "LeftSidePanelContentViewController.h"
#import "ProfileViewController.h"
#import "FindFriendsViewController.h"
#import "NewsFeedViewController.h"
#import <Parse/Parse.h>

@interface LeftSidePanelContentViewController ()

@end

@implementation LeftSidePanelContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - 75, 50, 100, 100)];
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x - 105, 165, 150, 50)];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 230, self.view.frame.size.width, 2.5)];
    line1.backgroundColor = [UIColor blackColor];
    UILabel *findFriends = [[UILabel alloc]initWithFrame:CGRectMake(10, 240, 100, 50)];
    findFriends.text = @"Find friends";
    UITapGestureRecognizer *showFriends = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(findFriends)];
    findFriends.userInteractionEnabled = YES;
    [findFriends addGestureRecognizer:showFriends];
    
    if ([PFUser currentUser]) {
        userNameLabel.text = [PFUser currentUser].username;
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        userNameLabel.font = [UIFont fontWithName:@"AlNile" size:20];
        PFFile *profilePicture = [PFUser currentUser][kProfilePictureKey];
        
        [profilePicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                NSLog(@"an error occured while fetching profile picture");
            }else{
                imageView.image = [UIImage imageWithData:data];
            }
        }];
    }
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showHome)];
    [imageView addGestureRecognizer:tapRecog];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:findFriends];
    [self.view addSubview:line1];
    [self.view addSubview:userNameLabel];
    [self.view addSubview:imageView];
}

-(void)showHome{
    NewsFeedViewController *newsCon = [[NewsFeedViewController alloc]init];
    [newsCon.newsNavigationController pushViewController:[[ProfileViewController alloc]init] animated:YES];
    
    
}
-(void)findFriends{
    NewsFeedViewController *newsCon = [[NewsFeedViewController alloc]init];
    [newsCon.newsNavigationController pushViewController:[[FindFriendsViewController alloc]init] animated:YES];
}

@end
