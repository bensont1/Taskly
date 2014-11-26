//
//  TaskTabViewController.h
//  Taskly
//
//  Created by Miles Laff on 10/13/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface TaskTabViewController : PFQueryTableViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, NSURLConnectionDelegate>

@end
