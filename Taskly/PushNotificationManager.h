//
//  PushNotificationManager.h
//  Taskly
//
//  Created by Miles Laff on 11/27/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import "Offer.h"

@interface PushNotificationManager : NSObject

+(void)sendOfferNotification:(PFObject *) offer;
+(void)sendResponseNotification:(PFObject *) task;

@end
