//
//  TaskManager.m
//  Taskly
//
//  Created by Miles Laff on 10/13/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "TaskManager.h"

@implementation TaskManager

+ (void)addTask:(Task *)task {
    PFObject *newTask = [PFObject objectWithClassName:@"Tasks"];
    [newTask setObject:task.title forKey:@"title"];
    [newTask setObject:task.details forKey:@"details"];
    [newTask setObject:task.price forKey:@"price"];
    [newTask setObject:task.owner forKey:@"owner"];
    [newTask setObject:task.filler forKey:@"filler"];
    [newTask setObject:task.location forKey:@"location"];
    [newTask setObject:task.expirationDate forKey:@"expirationDate"];
    [newTask setObject: [NSNumber numberWithBool:NO] forKey:@"completed"];
    [newTask saveInBackground];
}

+ (void)respondToTask:(PFObject *)task withOffer:(Offer *)offer {
    PFObject *newOffer = [PFObject objectWithClassName:@"Offers"];
    NSString *taskTitle = [task objectForKey:@"title"];
    [newOffer setObject:taskTitle forKey:@"title"];
    [newOffer setObject:offer.user forKey:@"user"];
    [newOffer setObject:offer.amount forKey:@"amount"];
    [newOffer setObject:offer.contactInfo forKey:@"contactInfo"];
    [newOffer setObject:offer.additionalDetails forKey:@"additionalDetails"];
    
    [newOffer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error) {
            PFRelation *taskRelation = [task relationForKey:@"offered"];
            [taskRelation addObject:newOffer];
            [task saveInBackground];
            
            PFRelation *offerRelation = [newOffer relationForKey:@"forTask"];
            [offerRelation addObject:task];
            [newOffer saveInBackground];
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

+(void)acceptFiller:(PFObject *)task withUser:(PFUser *)user {
    NSLog(@"Accept Filler Function");
    PFQuery *query = [PFQuery queryWithClassName:@"Tasks"];
    NSString *objectID = [task valueForKey:@"objectId"];
    NSLog(@"ID HERE: %@", objectID);
    [query getObjectInBackgroundWithId:objectID block:^(PFObject *object, NSError *error) {
        object[@"filler"] = user;
        object[@"completed"] = [NSNumber numberWithBool:YES];
        [object saveInBackground];
    }];
}

+ (NSString *)locationFromPlacemark:(CLPlacemark*)placemark {
    NSString *formattedLocation;
    
    formattedLocation = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
    
    //add address if available
    if(placemark.subThoroughfare != nil) {
        NSString *formattedLocationWithAddress = [NSString stringWithFormat:@"%@ %@, %@",
                             placemark.subThoroughfare,
                             placemark.thoroughfare,
                             formattedLocation];
        
        return formattedLocationWithAddress;
    }
    else {
        return formattedLocation;
    }
}

@end
