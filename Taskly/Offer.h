//
//  Offer.h
//  Taskly
//
//  Created by Miles Laff on 10/30/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Offer : NSObject

@property PFUser *user;
@property NSNumber *amount;
@property NSString *contactInfo;
@property NSString *additionalDetails;

@end
