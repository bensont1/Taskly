//
//  Task.h
//  Taskly
//
//  Created by Miles Laff on 10/13/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Task : NSObject

@property NSString *title;
@property NSString *detail;
@property NSNumber *price;
@property PFUser *user;

@end
