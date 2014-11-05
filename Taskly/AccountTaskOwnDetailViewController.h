//
//  AccountTaskOwnDetailViewController.h
//  Taskly
//
//  Created by Benson Truong on 11/5/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AccountTaskOwnDetailViewController : UIViewController

@property PFObject *task;
@property PFUser *taskFiller;

@end
