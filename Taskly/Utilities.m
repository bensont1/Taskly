//
//  Utilities.m
//  Taskly
//
//  Created by Benson Truong on 11/26/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

// function from http://stackoverflow.com/questions/7399343/making-a-uiimage-to-a-circle-form
+ (UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    [image drawInRect:imageView.bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

@end
