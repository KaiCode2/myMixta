//
//  NewsFeedViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-02.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "Constents.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface NewsFeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic)NSMutableArray *posts;

@end

@implementation NewsFeedViewController{
    UITextField *postField;
    NSString *postContent;
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    if (self) {
        CGFloat itemSpacing = 10.0;
        layout.minimumInteritemSpacing = itemSpacing;
        layout.itemSize = CGSizeMake(300, 75);
        layout.minimumLineSpacing = itemSpacing;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(150.0, 20.0);
        layout.footerReferenceSize = CGSizeMake(50.0, 50.0);
        
        layout.sectionInset = UIEdgeInsetsMake(150, 0, 50, 0);
        
        NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc]initWithString: @"Mixta"];
        [attrStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:0 green:0 blue:8 alpha:0.6] range: NSMakeRange(0, 5)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SnellRoundhand-Black" size:38.0] range:NSMakeRange(0, 5)];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.attributedText = attrStr;
        [titleLabel sizeToFit];
        self.navigationItem.titleView = titleLabel;
    }
    return (self = [super initWithCollectionViewLayout:layout]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    postContent = [[NSString alloc]init];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    self.posts = [[NSMutableArray alloc]init];
    
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
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"introBackground1.png"]];
    [self.collectionView addSubview:postField];
    [self.collectionView addSubview:postButton];
    
    UITapGestureRecognizer *resignKeyBoard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
    [self.collectionView addGestureRecognizer:resignKeyBoard];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self getPosts];
}

-(void)getPosts{
    PFQuery *query = [PFQuery queryWithClassName:kFollowClass];
    [query whereKey:kFollowSender equalTo:[PFUser currentUser]];
    [query whereKeyExists:kFollowReceiver];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error occured while getting users");
        }else{
            //NSLog(@"first object is %@", objects[0]);
            
            for (PFObject *object in objects){
//                PFObject *object1 = objects[0];
//                PFUser *objectUser = object1[kFollowReceiver];
//                PFUser *followedUser = [object objectForKey:kFollowReceiver];
                
                PFUser *followedUser = [object objectForKey:kFollowReceiver];
                NSLog(@"username is %@", followedUser);
                PFQuery *postsQuery = [PFQuery queryWithClassName:kTextClass];
                [postsQuery whereKey:kPostedBy equalTo:followedUser];
                
                [postsQuery findObjectsInBackgroundWithBlock:^(NSArray *theSecoundObjects, NSError *error) {
                    if (error) {
                        NSLog(@"an error occured while getting posts");
                    }else if (theSecoundObjects.count > 0){
                        NSLog(@"success on getting the posts and the posts is %@", theSecoundObjects[0][kPost]);
                        [self.posts addObjectsFromArray:theSecoundObjects];
                        [self.collectionView reloadData];
                    }else{
                        NSLog(@"there are no posts");
                    }
                }];
                
            }
            
        }
    }];
}

-(void)resignKeyboard{
    [postField resignFirstResponder];
}

-(void)post{
    [self resignKeyboard];
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
                postField.text = @"";
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.collectionView];
                hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rounded25.png"]];
                [self.collectionView addSubview:hud];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"Post successful!";
                hud.delegate = self;
                [hud show:YES];
                [hud hide:YES afterDelay:3];
            }
        }];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.posts count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

-(UITabBarItem*)tabBarItem{
    //TODO: move to init
    UITabBarItem* tabbar = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"letter28.png"] tag:0];
    [tabbar setImageInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    return tabbar;
}

@end
