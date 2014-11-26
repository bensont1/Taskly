//
//  Utilities.m
//  Taskly
//
//  Created by Benson Truong on 11/26/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "Utilities.h"
#import <Parse/Parse.h>

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

+ (UIImage *)getFBProfilePic
{
    __block UIImage *imageReturn = [UIImage imageNamed:@"placeholder_image.png"];
    if([[PFUser currentUser] objectForKey:@"facebookId"] != nil) {
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:@"facebookId"]]];
        NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
        [NSURLConnection sendAsynchronousRequest:profilePictureURLRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data,
                                                   NSError *connectionError) {
                                        imageReturn = [UIImage imageWithData:data];
                               }];
    }
    return imageReturn;
}

@end
