//
//  NewsFeedViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-02.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "NewsFeedViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface NewsFeedViewController ()

@end

@implementation NewsFeedViewController{
    UITextField *postField;
    NSString *kTextClass;
    NSString *kPostedBy;
    NSString *kPost;
    NSString *postContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    kTextClass = @"textPost";
    kPostedBy = @"postedBy";
    kPost = @"post";
    postContent = [[NSString alloc]init];
    
    postField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.center.x - 125, 50, 200, 40)];
    postField.placeholder = @"Post";
    postField.backgroundColor = [UIColor whiteColor];
    postField.textAlignment = NSTextAlignmentCenter;
    postField.layer.cornerRadius = 10;
    postField.layer.masksToBounds = YES;
    
    UIButton *postButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x + 75, 50, 40, 40)];
    postButton.backgroundColor = [UIColor colorWithRed:0 green:0.25 blue:0.75 alpha:0.45];
    [postButton setTitle:@"Post" forState:UIControlStateNormal];
    postButton.layer.cornerRadius = 10;
    postButton.layer.masksToBounds = YES;
    [postButton addTarget:self action:@selector(post) forControlEvents: UIControlEventTouchUpInside];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"introBackground1.png"]];
    [self.view addSubview:postField];
    [self.view addSubview:postButton];
    
    UITapGestureRecognizer *resignKeyBoard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:resignKeyBoard];
}

-(void)resignKeyboard{
    [postField resignFirstResponder];
}

-(void)post{
    postContent = postField.text;
    
    if (postContent.length == 0){
        UIAlertView *noText = [[UIAlertView alloc]initWithTitle:@"Oh no"
                                                        message:@"It appears there is no text to post"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [noText show];
    }else{
        PFObject *post = [PFObject objectWithClassName:kTextClass];
        [post setObject:[PFUser currentUser] forKey:kPostedBy];
        [post setObject:postContent forKey:kPost];
        
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error){
                UIAlertView *errorPosting = [[UIAlertView alloc]initWithTitle:@"Oh no"
                                                                      message:@"an error occured while trying to post."
                                                                     delegate:nil
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:@"OK", nil];
                [errorPosting show];
            }else if (succeeded == YES){
                NSLog(@"post successful");
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITabBarItem*)tabBarItem{
    UITabBarItem* tabbar = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"letter28.png"] tag:0];
    [tabbar setImageInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    return tabbar;
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
