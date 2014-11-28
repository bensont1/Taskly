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
+(void)sendOfferNotification:(PFObject *) offer {
    PFQuery *pushQuery = [PFQuery queryWithClassName:@"Tasks"];
    PFUser *taskOwner = [[offer objectForKey:@"forTask"] objectForKey:@"owner"];
    [pushQuery whereKey:@"owner" equalTo:taskOwner];
    
    [PFPush sendPushMessageToQueryInBackground:pushQuery withMessage:@"You have a new offer! Please check your Account page to view it."];
}

// when a task is saved, send push notifications to people who offered on it
+(void)sendResponseNotification:(PFObject *) task {
    PFQuery *pushQuery = [PFQuery queryWithClassName:@"Offers"];
    [pushQuery whereKey:@"forTask" equalTo:task];
    
    // we could use this later on if we want to send different messages to accepted/rejected offers
    //[pushQuery whereKey:@"user" notEqualTo:[task objectForKey:@"filler"];
     
    [PFPush sendPushMessageToQueryInBackground:pushQuery withMessage:@"Once of the tasks you've made an offer on has been updated. Please check your Account page to see the updates."];
}

@end
