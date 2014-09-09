//
//  UIImage+crop_image.h
//  Mixta
//
//  Created by kai don aldag on 2014-09-05.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (crop_image)

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;

@end
