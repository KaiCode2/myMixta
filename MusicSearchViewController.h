//
//  MusicSearchViewController.h
//  Mixta
//
//  Created by kai don aldag on 2014-09-08.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicSearchViewController : UICollectionViewController

@property (strong, nonatomic)AVQueuePlayer *player;

@end
