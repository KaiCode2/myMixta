//
//  PlayViewController.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-12.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()

@property (strong, nonatomic)UIImageView *coverImageView;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UIButton *pauseButton;
@property (strong, nonatomic)UIButton *playButton;
@property (strong, nonatomic)UIButton *nextButton;
@property (strong, nonatomic)UIButton *shareButton;

@end

@implementation PlayViewController

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
    self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 63, self.view.frame.size.width, self.view.frame.size.width)];
    self.coverImageView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.coverImageView];
}

@end
