//
//  AccountOfferDetailViewController.m
//  Taskly
//
//  Created by Miles Laff on 11/3/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "AccountOfferDetailViewController.h"

@interface AccountOfferDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *awaitingResponseView;
@property (weak, nonatomic) IBOutlet UIView *offerAcceptedView;
@property (weak, nonatomic) IBOutlet UIView *offerRejectedView;

@end

@implementation AccountOfferDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.awaitingResponseView.hidden = YES;
    self.offerAcceptedView.hidden = YES;
    self.offerRejectedView.hidden = YES;
    
    [self showCorrectView];
}

-(void)showCorrectView {
    if([PFUser currentUser] != nil) {
        PFRelation *relation = [self.offer relationForKey:@"forTask"];
        PFQuery *query = [relation query];
        [query includeKey:@"filler"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error) {
                PFObject *taskForOffer = [objects firstObject];
                NSLog(@"COMPLETE: %@", [taskForOffer objectForKey:@"completed"]);
                
                PFUser *fillerUser = [taskForOffer objectForKey:@"filler"];
                NSString *fillerID = [fillerUser valueForKey:@"objectId"];
                
                if([fillerID isEqualToString:@"JUTSUpXtKt"]){
                    self.awaitingResponseView.hidden = NO;
                }
                else {
                    // check if current user is filler, then accept
                    NSString *currentUserId = [[PFUser currentUser] valueForKey:@"objectId"];
                    if([fillerID isEqualToString:currentUserId]) {
                        self.offerAcceptedView.hidden = NO;
                    }
                    else {
                        self.offerRejectedView.hidden = NO;
                    }
                }
            }
            else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

@end
