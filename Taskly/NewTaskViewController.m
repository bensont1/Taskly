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

@interface NewTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *taskTitleField;
@property (weak, nonatomic) IBOutlet UITextView *additionalDetailField;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *hourMinutePicker;
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
    // Do any additional setup after loading the view.
    
    self.task = [[Task alloc] init];
    self.hourMinutePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    price = 10.00;
}

- (IBAction)incrementPrice:(id)sender {
    price++;
    [self updatePriceLabel];
}

- (IBAction)decrementPrice:(id)sender {
    price--;
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


#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     [self setTaskFields];
     NewTaskDetailViewController *destination = segue.destinationViewController;
     destination.task = self.task;
}

@end
