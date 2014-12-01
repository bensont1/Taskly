//
//  PushNotificationManager.m
//  Taskly
//
//  Created by Miles Laff on 11/27/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "PushNotificationManager.h"

@implementation PushNotificationManager

// when an offer is saved, send notification to task owner, telling them they have a new offer
+(void)sendOfferNotification:(PFObject *) task {
    PFObject *taskOwner = [task objectForKey:@"owner"];
    NSString *taskOwnerID = [taskOwner objectId];
    
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"objectId" equalTo:taskOwnerID];

    [PFPush sendPushMessageToQueryInBackground:userQuery withMessage:@"You have a new offer! Please check your Account page to view it."];
}

// when a task is saved, send push notifications to people who offered on it
+(void)sendResponseNotification:(PFObject *) task {
    PFQuery *pushQuery = [PFQuery queryWithClassName:@"Offers"];
    [pushQuery whereKey:@"forTask" equalTo:task];
    
    // we could use this later on if we want to send different messages to accepted/rejected offers
    //[pushQuery whereKey:@"user" notEqualTo:[task objectForKey:@"filler"];
     
    [PFPush sendPushMessageToQueryInBackground:pushQuery withMessage:@"One of the tasks you've made an offer on has been updated. Please check your Account page to see the updates."];
}

@end
