//
//  MusicSearchViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-08.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "MusicSearchViewController.h"

@interface MusicSearchViewController ()

@property (strong, nonatomic)UITextField *searchBar;
@property (strong, nonatomic)UIButton *searchButton;

@property (strong, nonatomic)NSMutableArray *results;

@end

@implementation MusicSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        layout.sectionInset = UIEdgeInsetsMake(150, 0, 20, 0);
        
        CGFloat itemSpacing = 15.0;
        layout.minimumInteritemSpacing = itemSpacing;
        layout.itemSize = CGSizeMake(250, 300);
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
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    self.searchBar = [[UITextField alloc]initWithFrame:CGRectMake(self.collectionView.center.x - 125, 20, 250, 40)];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"enter what your searching for";
    self.searchBar.textAlignment = NSTextAlignmentCenter;
    self.searchBar.layer.cornerRadius = 10;
    self.searchBar.layer.masksToBounds = YES;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.searchButton = [[UIButton alloc]initWithFrame:CGRectMake(self.collectionView.center.x - 125, 70, 250, 40)];
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
    NSString *userSearchEntry = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *searchUrlFormat = [NSString stringWithFormat:@"http://8tracks.com/mix_sets/all.json?keyword:%@?api_key=2ebc152a9e89f9a8f12316380e8f866138aeb4e8", userSearchEntry];
    
    NSURLRequest *trackRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:searchUrlFormat]];
    
    [NSURLConnection sendAsynchronousRequest:trackRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"we got a connection error!!!");
                               }else{
                                   NSLog(@"we got a response");
                                   id JSONResult = [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:0
                                                                                     error:nil];
                                   NSLog(@"the data is %@", JSONResult);
                                   
                                   //TODO: add data to self.results to populate the collectionView
                                   if ([JSONResult objectForKey:@"mixes"]) {
                                       [self.results addObjectsFromArray:[JSONResult objectForKey:@"mixes"]];
                                   }else{
                                       NSLog(@"no posts");
                                   }
                                   
                                   [self.collectionView reloadData];
                               }
                           }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.results count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *coverView = [[UIImageView alloc]initWithFrame:CGRectMake(cell.center.x - 110, 10, 150, 150)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 175, cell.frame.size.width, 50)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"demo";
    
    coverView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.95];
    
    cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.75];
    cell.layer.cornerRadius = 7.5;
    
    [cell addSubview:titleLabel];
    [cell addSubview:coverView];
    return cell;
}

@end
