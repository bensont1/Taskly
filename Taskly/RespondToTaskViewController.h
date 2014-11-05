//
//  RespondToTaskViewController.h
//  Taskly
//
//  Created by Miles Laff on 10/27/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface RespondToTaskViewController : UIViewController <UITextViewDelegate>

@property PFObject *task;

@end
