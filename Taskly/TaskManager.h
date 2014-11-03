//
//  TaskManager.h
//  Taskly
//
//  Created by Miles Laff on 10/13/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import "Offer.h"

@interface TaskManager : NSObject

+ (void)addTask:(Task *)task;
+ (void)respondToTask:(PFObject *)task withOffer:(Offer *)offer;

@end
