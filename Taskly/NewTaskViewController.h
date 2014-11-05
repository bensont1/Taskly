//
//  NewTaskViewController.h
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface NewTaskViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate>

@property Task *task;

-(void)resetFields;

@end
