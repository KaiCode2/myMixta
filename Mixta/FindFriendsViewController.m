//
//  FindFriendsViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-03.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "FindFriendsViewController.h"
#import "Constents.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface FindFriendsViewController ()  <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic)NSMutableArray *users;

@end

@implementation FindFriendsViewController{
    UICollectionViewFlowLayout *layout;
    UITextField *findUserField;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    layout = [[UICollectionViewFlowLayout alloc]init];
    
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        // Custom initialization
        
        UITabBarItem* tabbar = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"searching33.png"] tag:0];
        [tabbar setImageInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
        self.tabBarItem = tabbar;
        
        CGFloat itemSpacing = 10.0;
        layout.minimumInteritemSpacing = itemSpacing;
        layout.itemSize = CGSizeMake(300, 75);
        layout.minimumLineSpacing = itemSpacing;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(150.0, 20.0);
        layout.footerReferenceSize = CGSizeMake(50.0, 50.0);
        
        layout.sectionInset = UIEdgeInsetsMake(150, 0, 40, 0);
        
    }
    return self;
}

-(NSMutableArray*)users{
    if (!_users) {
        _users = [[NSMutableArray alloc]init];
    }
    return _users;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    findUserField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.center.x - 125, 50, 250, 40)];
    findUserField.backgroundColor = [UIColor whiteColor];
    UIView *usernameLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, findUserField.frame.size.height)];
    findUserField.leftView = usernameLeftView;
    findUserField.leftViewMode = UITextFieldViewModeAlways;
    findUserField.layer.cornerRadius = 10;
    findUserField.layer.masksToBounds = YES;
    findUserField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x - 125, 100, 250, 40)];
    searchButton.backgroundColor = [UIColor colorWithRed:0 green:0.1 blue:0.75 alpha:0.5];
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    searchButton.layer.cornerRadius = 10;
    searchButton.layer.masksToBounds = YES;
    [searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *resignKeyBoardRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
    [self.collectionView addGestureRecognizer:resignKeyBoardRecog];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SignUpBackGround.png"]];
    [self.collectionView addSubview:searchButton];
    [self.collectionView addSubview:findUserField];
}

-(void)resignKeyboard{
    [findUserField resignFirstResponder];
}

-(void)search{
    PFQuery *query = [PFUser query];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"Searching";
    [query whereKey:@"username" containsString:findUserField.text];
    [query whereKeyExists:@"profilePicture"];
    
    if (findUserField.text.length == 0) {
        UIAlertView *noText = [[UIAlertView alloc]initWithTitle:@"Oh no"
                                                        message:@"the text field was empty"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [noText show];
        [hud hide:YES];
    }else{
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                UIAlertView *errorFindingUsers = [[UIAlertView alloc]initWithTitle:@"Oh no"
                                                                           message:@"An error occured while fetching the users."
                                                                          delegate:nil
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"OK", nil];
                [errorFindingUsers show];
                [hud hide:YES];
            }else{
                [self.users addObjectsFromArray:objects];
                NSLog(@"query successful and the first user is %@", objects[0]);
                [self.collectionView reloadData];
                [hud hide:YES];
            }
        }];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.users count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, cell.frame.size.height - 20, cell.frame.size.height - 20)];
    
    PFFile *file = (PFFile*)self.users[indexPath.row][@"profilePicture"];
    
    NSLog(@"the file is %@", file.description);
    
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            NSLog(@"error is %@", error.description);
        }else{
            imageView.image = [FindFriendsViewController imageWithImage:[UIImage imageWithData:data] scaledToSize:CGSizeMake(40, 40)];
            [cell layoutSubviews];
        }
    }];
    for (UIView *myLabels in [cell subviews])
    {
        [myLabels removeFromSuperview];
    }
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 10, 100, 50)];
    userNameLabel.text = (NSString*)self.users[indexPath.row][@"username"];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:20];
    [cell addSubview:userNameLabel];
    [cell addSubview:imageView];
    cell.layer.cornerRadius = 7.5;
    cell.layer.masksToBounds = YES;
    
    cell.backgroundColor = [UIColor whiteColor];
    
    UIButton *followButton = [[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width - 60, 10, 50, 50)];
    [followButton setImage:[FindFriendsViewController imageWithImage:[UIImage imageNamed:@"add156.png"] scaledToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    followButton.backgroundColor = [UIColor colorWithRed:0 green:0.1 blue:0.7 alpha:0.75];
    [followButton addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
    followButton.layer.cornerRadius = 10;
    followButton.layer.masksToBounds = YES;
    
    [cell addSubview:followButton];
    
    return cell;
}

-(void)follow:(id)sender{
    NSLog(@"the sender is %@", sender);
    sender = (UIButton*)sender;
    
    UICollectionViewCell *senderCell = (UICollectionViewCell*)[sender superview];
    NSIndexPath *cellIndexPath = [self.collectionView indexPathForCell:senderCell];
    
    PFUser *receivingUser = self.users[cellIndexPath.row];
    
    PFObject *follow = [PFObject objectWithClassName:kFollowClass];
    follow[kFollowSender] = [PFUser currentUser];
    follow[kFollowReceiver] = receivingUser;
    [follow saveInBackground];
}

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
