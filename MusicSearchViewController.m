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

@end

@implementation MusicSearchViewController

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
    
    self.searchBar = [[UITextField alloc]initWithFrame:CGRectMake(self.view.center.x - 125, 20, 250, 40)];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"enter what your searching for";
    self.searchBar.textAlignment = NSTextAlignmentCenter;
    self.searchBar.layer.cornerRadius = 10;
    self.searchBar.layer.masksToBounds = YES;
    
    self.searchButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x - 125, 70, 250, 40)];
    self.searchButton.layer.cornerRadius = 10;
    self.searchButton.layer.masksToBounds = YES;
    self.searchButton.backgroundColor = [UIColor blueColor];
    [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *resignKeyBoard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboar)];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addGestureRecognizer:resignKeyBoard];
    [self.view addSubview:self.searchButton];
    [self.view addSubview:self.searchBar];
}

-(void)resignKeyboar{
    [self.searchBar resignFirstResponder];
}

-(void)search{
    NSString *userSearchEntry = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *searchUrlFormat = [NSString stringWithFormat:@""];
    
    NSString *URLString = [NSString stringWithFormat:@"http://8tracks.com/mixes.json?api_key=2ebc152a9e89f9a8f12316380e8f866138aeb4e8"];
    NSURLRequest *trackRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:URLString]];
    
    [NSURLConnection sendAsynchronousRequest:trackRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"we got a connection error!!!");
                               }else{
                                   NSLog(@"we got a response");
                                   id JSONString = [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:0
                                                                                     error:nil];
                                   NSLog(@"the data is %@", JSONString);
                               }
                           }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
