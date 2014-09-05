//
//  ProfileViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-03.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc]initWithString:[PFUser currentUser].username];
        [attrStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:0 green:0 blue:8 alpha:0.6] range: NSMakeRange(0, [PFUser currentUser].username.length)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SnellRoundhand-Black" size:38.0] range:NSMakeRange(0, [PFUser currentUser].username.length)];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.attributedText = attrStr;
        [titleLabel sizeToFit];
        self.navigationItem.titleView = titleLabel;
    }
    return self;
}

-(UITabBarItem*)tabBarItem{
    //TODO: move to init
    UITabBarItem* tabbar = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"user47.png"] tag:0];
    [tabbar setImageInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    return tabbar;
}

@end
