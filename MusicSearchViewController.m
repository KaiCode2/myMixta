//
//  MusicSearchViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-08.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "MusicSearchViewController.h"
#import "Constents.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>

@interface MusicSearchViewController () <MBProgressHUDDelegate>

@property (strong, nonatomic)UITextField *searchBar;
@property (strong, nonatomic)UIButton *searchButton;

@property (strong, nonatomic)NSMutableArray *results;

@property (nonatomic, strong) id timeObserver;

@end

@implementation MusicSearchViewController{
    AVQueuePlayer *player;
    MBProgressHUD *playHud;
    NSString *trackID;
    NSString *userToken;
    id JSON;
    NSString *songTitle;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        UITabBarItem* tabbar = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"audio.png"] tag:0];
        [tabbar setImageInsets:UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)];
        self.tabBarItem = tabbar;
        
        layout.sectionInset = UIEdgeInsetsMake(150, 0, 20, 0);
        
        CGFloat itemSpacing = 15.0;
        layout.minimumInteritemSpacing = itemSpacing;
        layout.itemSize = CGSizeMake(250, 400);
        layout.minimumLineSpacing = itemSpacing;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(150.0, 20.0);
        layout.footerReferenceSize = CGSizeMake(50.0, 50.0);
    }
    return self;
}

-(NSMutableArray *)results{
    if (!_results) {
        _results = [[NSMutableArray alloc]init];
    }
    return _results;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getUserToken];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    player = [[AVQueuePlayer alloc]init];
    trackID = [[NSString alloc]init];
    userToken = [[NSString alloc]init];
    
    // Set AVAudioSession
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    // Change the default output audio route
    
    //MIGHT NEED THE CODE BELOW BUT IT WORKS WITHOUT IT SO... WHATEVER
//    UInt32 doChangeDefaultRoute = 1;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
//                            sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    
    void (^observerBlock)(CMTime time) = ^(CMTime time) {
        NSString *timeString = [NSString stringWithFormat:@"%02.2f", (float)time.value / (float)time.timescale];
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
            songTitle = timeString;
        } else {
            NSLog(@"App is backgrounded. Time is: %@", timeString);
        }
    };
    
    self.timeObserver = [player addPeriodicTimeObserverForInterval:CMTimeMake(10, 1000)
                                                                  queue:dispatch_get_main_queue()
                                                             usingBlock:observerBlock];
    
    self.searchBar = [[UITextField alloc]initWithFrame:CGRectMake(self.collectionView.center.x - 125, 40, 250, 40)];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"enter what your searching for";
    self.searchBar.textAlignment = NSTextAlignmentCenter;
    self.searchBar.layer.cornerRadius = 10;
    self.searchBar.layer.masksToBounds = YES;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.searchButton = [[UIButton alloc]initWithFrame:CGRectMake(self.collectionView.center.x - 125, 90, 250, 40)];
    self.searchButton.layer.cornerRadius = 10;
    self.searchButton.layer.masksToBounds = YES;
    self.searchButton.backgroundColor = [UIColor blueColor];
    [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *resignKeyBoard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"searcgBackground.png"]];
    [self.collectionView addGestureRecognizer:resignKeyBoard];
    [self.collectionView addSubview:self.searchButton];
    [self.collectionView addSubview:self.searchBar];
}

-(void)resignKeyboard{
    [self.searchBar resignFirstResponder];
}

-(void)search{
    [self resignKeyboard];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"Searching, please wait";
    [hud show:YES];
    NSString *userSearchEntry = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *userString = [userSearchEntry stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"the search is %@", userSearchEntry);
    
    NSString *searchUrlFormat = [NSString stringWithFormat:@"http://8tracks.com/mix_sets/keyword:%@.json?api_key=2ebc152a9e89f9a8f12316380e8f866138aeb4e8", userString];
    
    NSURLRequest *trackRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:searchUrlFormat]];
    
    [NSURLConnection sendAsynchronousRequest:trackRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"we got a connection error!!!");
                                   [hud hide:YES];
                                   MBProgressHUD *eHud = [[MBProgressHUD alloc] initWithView:self.collectionView];
                                   eHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cloud263.png"]];
                                   [self.collectionView addSubview:eHud];
                                   eHud.mode = MBProgressHUDModeCustomView;
                                   eHud.labelText = @"error fetching posts";
                                   eHud.delegate = self;
                                   [eHud show:YES];
                                   [eHud hide:YES afterDelay:3];
                               }else{
                                   NSLog(@"we got a response");
                                   id JSONResult = [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:0
                                                                                     error:nil];
                                   
                                   if ([JSONResult objectForKey:@"mixes"]) {
                                       [self.results removeAllObjects];
                                       [self.results addObjectsFromArray:[JSONResult objectForKey:@"mixes"]];
                                   }else{
                                       NSLog(@"no posts");
                                   }
                                   [self.collectionView reloadData];
                                   [hud hide:YES];
                               }
                           }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.results count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    for (UIView *myLabels in [cell subviews])
    {
        [myLabels removeFromSuperview];
    }
    
    UIImageView *coverView = [[UIImageView alloc]initWithFrame:CGRectMake(cell.center.x - 110, 10, 150, 150)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 165, cell.frame.size.width, 70)];
    UIButton *playButton = [[UIButton alloc]initWithFrame:CGRectMake(40, cell.frame.size.height - 65, 50, 50)];
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(160, cell.frame.size.height - 65, 50, 50)];
    [shareButton setImage:[UIImage imageNamed:@"share10.png"] forState:UIControlStateNormal];
    shareButton.backgroundColor = [UIColor clearColor];
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [playButton setImage:[UIImage imageNamed:@"play15.png"] forState:UIControlStateNormal];
    playButton.backgroundColor = [UIColor clearColor];
    [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    titleLabel.numberOfLines = 2;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [[self.results objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[self.results objectAtIndex:indexPath.row]objectForKey:@"cover_urls"]objectForKey:@"max200"]]];
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"we have a connection error");
                               }else{
                                   NSLog(@"we got a network response");
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       UIImage *image = [UIImage imageWithData:data];
                                       coverView.image = image;
                                   });
                               }
                           }];

    
    
    coverView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.95];
    
    cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.75];
    cell.layer.cornerRadius = 7.5;
    
    [cell addSubview:shareButton];
    [cell addSubview:playButton];
    [cell addSubview:titleLabel];
    [cell addSubview:coverView];
    return cell;
}

-(void)share:(UIButton*)sender{
    UICollectionViewCell *senderCell = (UICollectionViewCell*)[sender superview];
    NSIndexPath *cellIndexPath = [self.collectionView indexPathForCell:senderCell];
    
    
}

-(void)getUserToken{
    PFQuery *query = [PFUser query];
    [query whereKeyExists:kEightTrackToken];
    
    __block NSString *aUserToken = [[NSString alloc]init];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"an error occured while fetching the user token");
            [playHud hide:YES];
        }else{
            aUserToken = [[objects objectAtIndex:0] objectForKey:kEightTrackToken];
            userToken = aUserToken;
            NSLog(@"user data is %@", userToken);
        }
    }];
}

-(void)play:(UIButton*)sender{
    UICollectionViewCell *senderCell = (UICollectionViewCell*)[sender superview];
    NSIndexPath *cellIndexPath = [self.collectionView indexPathForCell:senderCell];
    
    NSString *pathOfID = [[self.results objectAtIndex:cellIndexPath.row]objectForKey:@"id"];
    trackID = pathOfID;
    
    playHud = [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    playHud.mode = MBProgressHUDAnimationFade;
    playHud.labelText = @"Loading, please wait";
    [playHud show:YES];
    
    NSString *path = [NSString stringWithFormat:@"http://8tracks.com/sets/%@/play.json?mix_id=%@&api_key=2ebc152a9e89f9a8f12316380e8f866138aeb4e8", userToken, pathOfID];
            
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    NSLog(@"the request is %@", request.URL);
    [NSURLConnection sendAsynchronousRequest:request
                                        queue:[NSOperationQueue mainQueue]
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                if (connectionError) {
                                    NSLog(@"the connection error is %@", connectionError.description);
                                    [playHud hide:YES];
                                }else{
                                    JSON = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:0
                                                                                error:nil];
                                    NSLog(@"the JSON is %@", JSON);
                                    NSLog(@"player URL is %@", [[[JSON objectForKey:@"set"] objectForKey:@"track"] objectForKey:@"url"]);
                                    songTitle = [[[JSON objectForKey:@"set"] objectForKey:@"track"] objectForKey:@"url"];
                                    
                                    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:[[[JSON objectForKey:@"set"] objectForKey:@"track"] objectForKey:@"url"]] options:nil];
                                    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
                                           
                                    player = [AVQueuePlayer playerWithPlayerItem:item];
                                    [player addObserver:self
                                             forKeyPath:@"status"
                                                options:0
                                                context:nil];
                                    
                                    [player addObserver:self
                                             forKeyPath:@"currentItem"
                                                options:NSKeyValueObservingOptionNew
                                                context:nil];
                                    
                                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNextSong) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
                                }
                            }];
    
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary  *)change
                        context:(void *)context {
    
    if (object == player && [keyPath isEqualToString:@"status"]) {
        if (player.status == AVPlayerStatusReadyToPlay) {
            [player play];
            [playHud hide:YES];
        }
        else if (player.status == AVPlayerStatusFailed) {
            NSLog(@"Something went wrong: %@", player.error);
            [playHud hide:YES];
        }
    }
    if ([keyPath isEqualToString:@"currentItem"])
    {
        AVPlayerItem *item = ((AVPlayer *)object).currentItem;
        songTitle = ((AVURLAsset*)item.asset).URL.pathComponents.lastObject;
    }
}

-(void)addNextSong{
    [self removeObserver:self forKeyPath:AVPlayerItemDidPlayToEndTimeNotification];
    NSString *urlString = [NSString stringWithFormat:@"http://8tracks.com/sets/%@/next.json?mix_id=%@&api_key=2ebc152a9e89f9a8f12316380e8f866138aeb4e8", userToken, trackID];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"connection error while loading next song");
                               }else{
                                   id theJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:0
                                                                               error:nil];
                                   AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:[[[theJSON objectForKey:@"set"] objectForKey:@"track"] objectForKey:@"url"]] options:nil];
                                   AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
                                   
                                   [player insertItem:anItem afterItem:[[player items] lastObject]];
                                   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNextSong) name:AVPlayerItemDidPlayToEndTimeNotification object:anItem];
                               }
                           }];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
