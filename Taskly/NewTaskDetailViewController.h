//
//  NewTaskDetailViewController.h
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Task.h"

@interface NewTaskDetailViewController : UIViewController <UISearchBarDelegate>

@property Task *task;

@end
