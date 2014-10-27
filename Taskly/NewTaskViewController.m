//
//  NewTaskViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "NewTaskViewController.h"
#import "NewTaskDetailViewController.h"
#import "Task.h"
#define PLACEHOLDER_TEXT @"Fill in additional details here"

@interface NewTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *taskTitleField;
@property (weak, nonatomic) IBOutlet UITextView *additionalDetailField;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *hourMinutePicker;

- (IBAction)continueToDetailPage:(id)sender;
- (IBAction)incrementPrice:(id)sender;
- (IBAction)decrementPrice:(id)sender;

@end

@implementation NewTaskViewController {
    NSString *title;
    NSString *details;
    float price;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.task = [[Task alloc] init];
    self.hourMinutePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    price = 10.00;
}

- (IBAction)incrementPrice:(id)sender {
    price++;
    [self updatePriceLabel];
}

- (IBAction)decrementPrice:(id)sender {
    if(price > 0) {
        price--;
    }
    [self updatePriceLabel];
}

- (void)updatePriceLabel {
    self.priceLabel.text = [NSString stringWithFormat:@"$%1.2f", price];
}

- (void)setTaskFields {
    self.task.title = self.taskTitleField.text;
    self.task.details = self.additionalDetailField.text;
    self.task.price = [NSNumber numberWithFloat:price];
    self.task.duration = [NSNumber numberWithInt:self.hourMinutePicker.countDownDuration]; //picker gives seconds only so store as seconds
}

- (IBAction)continueToDetailPage:(id)sender {
    NSLog(@"%lu",(unsigned long)self.taskTitleField.text.length);
    if(self.taskTitleField.text.length == 0) {
        [self showNoTitleAlert];
    }
    else if(![self verifyAdditionalDetailsField]) {
        [self showNoAdditionalDetailsAlert];
    }
    else {
        [self performSegueWithIdentifier:@"toNewTaskDetailViewController" sender:self];
    }
}

- (BOOL)verifyAdditionalDetailsField {
    if(self.additionalDetailField.text.length == 0) {
        return NO;
    }
    if([self.additionalDetailField.text isEqualToString:@"Fill in additional details here"]) {
        return NO;
    }
    return YES;
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

#pragma mark - Alerts

-(void)showNoTitleAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Title"
                                message:@"Please add a title to your task before continuing."
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil];
    
    [alert setTag:1];
    [alert show];
}

-(void)showNoAdditionalDetailsAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No details"
                                message:@"You didn't fill out any additional details. Are you sure you want to continue?"
                               delegate:self
                      cancelButtonTitle:@"Add Details"
                      otherButtonTitles:@"Continue", nil];
    
    [alert setTag:2];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 2) //showNoAdditionalDetailsAlert is active
        if(buttonIndex == 1) {
            [self performSegueWithIdentifier:@"toNewTaskDetailViewController" sender:self];
        }
}


#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     [self setTaskFields];
     NewTaskDetailViewController *destination = segue.destinationViewController;
     destination.task = self.task;
}

@end
