//
//  IntroViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-03.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "IntroViewController.h"
#import "NewsFeedViewController.h"
#import <EAIntroView/EAIntroView.h>
#import <Parse/Parse.h>

@interface IntroViewController () <EAIntroDelegate>

@end

@implementation IntroViewController

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
    EAIntroPage *introPage = [EAIntroPage page];
    introPage.title = [NSString stringWithFormat:@"Welcome to Mixta, %@", [PFUser currentUser].username];
    introPage.desc = @"Mixta is an app where you can listen to personalized music and share it to all your friends.";
    UIImage *image1 = [UIImage imageNamed:@"introBackground1.png"];
    introPage.bgImage = image1;
    introPage.titlePositionY = 400;
    introPage.descPositionY = 350;
    introPage.titleColor = [UIColor blackColor];
    introPage.descColor = [UIColor blackColor];
    
    EAIntroPage *secoundPage = [EAIntroPage page];
    secoundPage.title = @"Your sound feed";
    secoundPage.desc = @"This is a wall where all the people you're following's music will show up along with what they thought of it.";
    secoundPage.titleColor = [UIColor whiteColor];
    secoundPage.descColor = [UIColor whiteColor];
    secoundPage.titlePositionY = 400;
    secoundPage.descPositionY = 350;
    
    EAIntroView *introView = [[EAIntroView alloc]initWithFrame:self.view.bounds andPages:@[introPage, secoundPage]];
    introView.delegate = self;
    [introView showInView:self.view animateDuration:0];
    [introView.skipButton addTarget:self action:@selector(skipSlides) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)skipSlides{
    NewsFeedViewController *viewCon = [[NewsFeedViewController alloc]init];
    [self presentViewController:viewCon animated:YES completion:nil];
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
