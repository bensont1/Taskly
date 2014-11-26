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

- (IBAction)clearButton:(id)sender;
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
    [self setFillerToNullUser];
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
    if([PFUser currentUser]) {
        self.task.owner = [PFUser currentUser];
        self.task.title = self.taskTitleField.text;
        self.task.details = self.additionalDetailField.text;
        self.task.price = [NSNumber numberWithFloat:price];
        
        //set time zone of Parse createdAt object
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [cal setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        
        //NSDateComponents *timeZoneComps=[[NSDateComponents alloc] init];
        //[timeZoneComps set]
        
        NSDate *now = [NSDate date];
        NSDate *expirationDate = [now dateByAddingTimeInterval:self.hourMinutePicker.countDownDuration];
        
        //NSDateComponents *timeZoneComps = [cal components:NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:expirationDate];
        //NSDate *date=[cal dateFromComponents:timeZoneComps];
        
        self.task.expirationDate = expirationDate;
    }
}

- (void)setFillerToNullUser {
    PFQuery *nullUserQuery = [PFUser query];
    [nullUserQuery whereKey:@"username" equalTo:@"null"];
    [nullUserQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.task.filler = [objects firstObject];
    }];
}

- (IBAction)clearButton:(id)sender {
    [self resetFields];
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

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.taskTitleField endEditing:YES];
    [self.additionalDetailField endEditing:YES];
    
}

-(void)resetFields {
    self.taskTitleField.text = @"";
    self.additionalDetailField.text = @"Fill in additional details here";
    self.priceLabel.text = @"$10.00";
    
    NSTimeInterval defaultTime = 0.00;
    self.hourMinutePicker.countDownDuration = defaultTime;
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

-(void)showNotLoggedInAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Logged In"
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
    destination.taskNewController = self;
}

@end
