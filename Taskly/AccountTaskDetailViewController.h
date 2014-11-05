//
//  AccountTaskDetailViewController.h
//  Taskly
//
//  Created by Miles Laff on 11/3/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AccountTaskDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property PFObject *task;

@end
