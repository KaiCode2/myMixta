//
//  ProfileViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-03.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "ProfileViewController.h"
#import "Constents.h"
#import "UIImage+crop_image.h"
#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ProfileViewController () <MBProgressHUDDelegate>

@end

@implementation ProfileViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([PFUser currentUser]) {
            NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc]initWithString:[PFUser currentUser].username];
            [attrStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:0 green:0 blue:8 alpha:0.6] range: NSMakeRange(0, [PFUser currentUser].username.length)];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SnellRoundhand-Black" size:38.0] range:NSMakeRange(0, [PFUser currentUser].username.length)];
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.attributedText = attrStr;
            [titleLabel sizeToFit];
            self.navigationItem.titleView = titleLabel;
        }else{
            NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc]initWithString:@"Home"];
            [attrStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:0 green:0 blue:8 alpha:0.6] range: NSMakeRange(0, 4)];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SnellRoundhand-Black" size:38.0] range:NSMakeRange(0, 4)];
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.attributedText = attrStr;
            [titleLabel sizeToFit];
            self.navigationItem.titleView = titleLabel;
        }
        
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - 50, 150, 100, 100)];
    if ([PFUser currentUser]) {
        PFFile *profilePicture = [PFUser currentUser][kProfilePictureKey];
        
        [profilePicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                NSLog(@"an error occured while fetching profile picture");
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"cloud263.png"] scaledToSize:CGSizeMake(100, 100)]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"Couldn't get profile picture";
                hud.delegate = self;
                [hud show:YES];
                [hud hide:YES afterDelay:3];
            }else{
                imageView.image = [UIImage imageWithData:data];
            }
        }];
    }
    
    [self.view addSubview:imageView];
}

-(UITabBarItem*)tabBarItem{
    //TODO: move to init
    UITabBarItem* tabbar = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"user47.png"] tag:0];
    [tabbar setImageInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    return tabbar;
}

@end
