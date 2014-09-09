//
//  UIImage+crop_image.m
//  Mixta
//
//  Created by kai don aldag on 2014-09-05.
//  Copyright (c) 2014 kai.don.aldag. All rights reserved.
//

#import "UIImage+crop_image.h"

@implementation UIImage (crop_image)

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
