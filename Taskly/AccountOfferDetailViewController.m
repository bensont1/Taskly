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
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error) {
                PFObject *taskForOffer = [objects firstObject];
                
                if([taskForOffer objectForKey:@"completed"] == NO) {
                    self.awaitingResponseView.hidden = NO;
                }
                else {
                    NSString *fillerID = [[taskForOffer objectForKey:@"filler"] objectId];
                    NSString *currentUserID = [[PFUser currentUser] objectId];
                    
                    if([fillerID isEqualToString:currentUserID]) {
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
