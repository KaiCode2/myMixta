//
//  NewsFeedViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-02.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "Constents.h"
#import "UIImage+crop_image.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface NewsFeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MBProgressHUDDelegate>

@property (strong, nonatomic)NSMutableArray *posts;
@property (strong, nonatomic)NSMutableArray *users;

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
        layout.itemSize = CGSizeMake(300, 200);
        layout.minimumLineSpacing = itemSpacing;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(100.0, 20.0);
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
    [query orderByDescending:kFollowReceiver];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error occured while getting users");
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.collectionView];
            hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloud263.png"]];
            [self.collectionView addSubview:hud];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"error fetching posts";
            hud.delegate = self;
            [hud show:YES];
            [hud hide:YES afterDelay:3];
        }else{
            NSMutableSet *users = [[NSMutableSet alloc]init];
            if (objects) {
                for (int i = 0; i < objects.count ; i++) {
                    NSLog(@"the user is %@", objects[i]);
                    [users addObject:[objects[i] objectForKey:kFollowReceiver]];
                }
            }else{
                NSLog(@"there are no objects!!!");
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.collectionView];
                hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloud263.png"]];
                [self.collectionView addSubview:hud];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"there are no posts";
                hud.delegate = self;
                [hud show:YES];
                [hud hide:YES afterDelay:3];
            }
            [self.users addObjectsFromArray:[users allObjects]];
            
            PFQuery *postsQuery = [PFQuery queryWithClassName:kTextClass];
            [postsQuery whereKey:kPostedBy containedIn:[users allObjects]];
            [postsQuery orderByDescending:kPostedBy];
            
            [postsQuery findObjectsInBackgroundWithBlock:^(NSArray *theSecoundObjects, NSError *error) {
                if (error) {
                    
                    NSLog(@"an error occured while getting posts");
                    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.collectionView];
                    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloud263.png"]];
                    [self.collectionView addSubview:hud];
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"error fetching posts";
                    hud.delegate = self;
                    [hud show:YES];
                    [hud hide:YES afterDelay:3];
                }else if (theSecoundObjects.count > 0){
                    
                    NSLog(@"success on getting the posts and the posts is %@", theSecoundObjects[0][kPost]);
                    [self.posts addObjectsFromArray:theSecoundObjects];
                    [self.collectionView reloadData];
                }else if (theSecoundObjects.count > 0){
                    
                    NSLog(@"there are posts in object");
                    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.collectionView];
                    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloud263.png"]];
                    [self.collectionView addSubview:hud];
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"there are no posts";
                    hud.delegate = self;
                    [hud show:YES];
                    [hud hide:YES afterDelay:3];
                }else if (theSecoundObjects.count == 0){
                    
                    NSLog(@"no objects in objects");
                    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.collectionView];
                    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloud263.png"]];
                    [self.collectionView addSubview:hud];
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"there are no posts";
                    hud.delegate = self;
                    [hud show:YES];
                    [hud hide:YES afterDelay:3];
                }
            }];
                
            
            
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
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.collectionView];
                hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloud263.png"]];
                [self.collectionView addSubview:hud];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"an error occured while trying to post";
                hud.delegate = self;
                [hud show:YES];
                [hud hide:YES afterDelay:3];
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
//    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    //TODO: this is hacky as hell so change it ASAP
    for (UIView *myLabels in [cell subviews])
    {
        [myLabels removeFromSuperview];
    }
    
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 100, 50)];
    UILabel *postContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 100, cell.frame.size.width, 75)];
    UIImageView *profileView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    NSLog(@"the array is %@", self.posts[indexPath.row][kPostedBy]);
    PFUser *aUser = self.posts[indexPath.row][kPostedBy];
    NSLog(@"the post content is %@", [self.posts[indexPath.row]objectForKey:kPost]);
    postContentLabel.text = [self.posts[indexPath.row]objectForKey:kPost];
//    postContentLabel.text = self.posts[indexPath.row];
    [aUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            NSLog(@"failed to get profile picture");
        }else{
            NSLog(@"we got a user");
            PFFile *profilePictureFile = object[kProfilePictureKey];
            [profilePictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                profileView.image = [UIImage imageWithImage:[UIImage imageWithData:data] scaledToSize:CGSizeMake(50, 50)];
            }];
            userNameLabel.text = object[kUserName];
        }
    }];
    
    profileView.backgroundColor = [UIColor clearColor];
    profileView.layer.cornerRadius = 7.5;
    profileView.layer.masksToBounds = YES;
    
    [cell addSubview:postContentLabel];
    [cell addSubview:userNameLabel];
    [cell addSubview:profileView];
    return cell;
}

-(UITabBarItem*)tabBarItem{
    //TODO: move to init
    UITabBarItem* tabbar = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"letter28.png"] tag:0];
    [tabbar setImageInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    return tabbar;
}

@end
