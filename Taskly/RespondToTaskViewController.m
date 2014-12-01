//
//  RespondToTaskViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/27/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "RespondToTaskViewController.h"
#import "TaskManager.h"
#import "PushNotificationManager.h"

#define PLACEHOLDER_TEXT @"You can add a personal message here if you'd like."

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
    
    self.additionalDetailsField.delegate = self;
    
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
        if([self checkAlreadyRespond]) {
            [self showAlreadyRespondedAlert];
        }
        else {
            [TaskManager respondToTask:self.task withOffer:self.offer];
            [self showSuccessfulResponseAlert];
            [PushNotificationManager sendOfferNotification:self.task];
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)checkAlreadyRespond {
    PFRelation *relation = [self.task relationForKey:@"offered"];
    PFQuery *query = [relation query];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    PFObject *testIfQuerySuccess = [query getFirstObject];
    
    if(testIfQuerySuccess) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - Alerts

-(void)showFillOutContactInfoAlert {
    UIAlertView *contactInfoErrorAlert = [[UIAlertView alloc] initWithTitle:@"Form Incomplete"
                                message:@"Please fill out the contact information section. If your offer is accepted, the owner needs a way to get in touch with you!"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil];
    [contactInfoErrorAlert setTag:0];
    [contactInfoErrorAlert show];
}

-(void)showSuccessfulResponseAlert {
    UIAlertView *responseSuccessAlert = [[UIAlertView alloc] initWithTitle:@"Offer Sent!"
                                message:@"Your offer has been successfully sent to the task owner. We'll let you know if you are chosen, and you can also check the status of this offer on the Account page."
                               delegate:self
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil];
    [responseSuccessAlert setTag:1];
    [responseSuccessAlert show];
}

-(void)showAlreadyRespondedAlert {
    UIAlertView *alreadyRespondAlert = [[UIAlertView alloc] initWithTitle:@"Already Responded"
                                message:@"You have already responded to this Task. Check the Account Page to see if the Task Owner has accepted your offer."
                               delegate:self
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil];
    [alreadyRespondAlert setTag:2];
    [alreadyRespondAlert show];
}

#pragma mark - TextView Delegation

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:PLACEHOLDER_TEXT]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if([textView.text isEqualToString: @""]) {
        textView.text = PLACEHOLDER_TEXT;
    }
}

#pragma mark - Alert Delgation
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1 || alertView.tag == 2) {
        if(buttonIndex != [alertView cancelButtonIndex]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


@end
