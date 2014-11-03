//
//  RespondToTaskViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/27/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "RespondToTaskViewController.h"
#import "TaskManager.h"

@interface RespondToTaskViewController ()

@property Offer *offer;
@property (weak, nonatomic) IBOutlet UITextField *contactField;
@property (weak, nonatomic) IBOutlet UITextView *additionalDetailsField;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

- (IBAction)incrementAmount:(id)sender;
- (IBAction)decrementAmount:(id)sender;

@end

@implementation RespondToTaskViewController {
    NSString *contact;
    NSString *additionalDetails;
    float amount;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Submit"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(submitResponse)];
    self.navigationItem.rightBarButtonItem = submitButton;
    
    self.offer = [[Offer alloc] init];
    amount = 10.00;
}

- (IBAction)incrementAmount:(id)sender {
    amount++;
    [self updateAmountLabel];
}

- (IBAction)decrementAmount:(id)sender {
    if(amount > 0) {
        amount--;
    }
    [self updateAmountLabel];
}

-(void)updateAmountLabel {
    self.amountLabel.text = [NSString stringWithFormat:@"$%1.2f", amount];
}

- (void)setFields {
    if([PFUser currentUser]) {
        self.offer.user = [PFUser currentUser];
        self.offer.amount = [NSNumber numberWithFloat:amount];
        self.offer.contactInfo = self.contactField.text;
        self.offer.additionalDetails = self.additionalDetailsField.text;
    }
}

- (void)submitResponse {
    if(self.contactField.text.length == 0) {
        [self showFillOutContactInfoAlert];
    }
    else {
        [self setFields];
        [TaskManager respondToTask:self.task withOffer:self.offer];
        [self showSuccessfulResponseAlert];
        //segue to main page, idk how
    }
}

#pragma mark - Alerts

-(void)showFillOutContactInfoAlert {
    [[[UIAlertView alloc] initWithTitle:@"Form Incomplete"
                                message:@"Please fill out the contact information section. If your offer is accepted, the owner needs a way to get in touch with you!"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

-(void)showSuccessfulResponseAlert {
    [[[UIAlertView alloc] initWithTitle:@"Offer Sent!"
                                message:@"Your offer has been successfully sent to the task owner. We'll let you know if you are chosen, and you can also check the status of this offer on the Account page."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
