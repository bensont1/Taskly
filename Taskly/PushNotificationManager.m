//
//  PushNotificationManager.m
//  Taskly
//
//  Created by Miles Laff on 11/27/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "PushNotificationManager.h"

@implementation PushNotificationManager

+(void)sendOfferNotification:(PFObject *) offer {
    PFQuery *pushQuery = [PFQuery queryWithClassName:@"Tasks"];
    PFUser *taskOwner = [[offer objectForKey:@"forTask"] objectForKey:@"owner"];
    
    [pushQuery whereKey:@"owner" equalTo:taskOwner];
    
    [PFPush sendPushMessageToQueryInBackground:pushQuery withMessage:@"You have a new offer! Please check your Account page to view it."];
}

+(void)sendResponseNotification:(PFObject *) task {
    //ill do this later
}

@end
