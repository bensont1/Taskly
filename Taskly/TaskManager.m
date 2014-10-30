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
    [newTask saveInBackground];
}

+ (void)respondToTask:(Task *)task {
    
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
