//
//  NewTaskDetailViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "NewTaskDetailViewController.h"

@interface NewTaskDetailViewController ()

- (IBAction)incrementPrice:(id)sender;
- (IBAction)decrementPrice:(id)sender;
- (IBAction)incrementHour:(id)sender;
- (IBAction)decrementHour:(id)sender;
- (IBAction)incrementMinutes:(id)sender;
- (IBAction)decrementMinutes:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;

@end

@implementation NewTaskDetailViewController {
    float price;
    int hours;
    int minutes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addTaskButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Add Task"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                      action:@selector(addTask:)];
    self.navigationItem.rightBarButtonItem = addTaskButton;
    
    price = 10;
    hours = 1;
    minutes = 0;
}

- (IBAction)incrementPrice:(id)sender {
    price++;
    self.priceLabel.text = [NSString stringWithFormat:@"$%1.2f", price];
}

- (IBAction)decrementPrice:(id)sender {
    price--;
    self.priceLabel.text = [NSString stringWithFormat:@"$%1.2f", price];
}

- (IBAction)incrementHour:(id)sender {
    hours++;
    self.hoursLabel.text = [NSString stringWithFormat:@"%d hour", hours];
}

- (IBAction)decrementHour:(id)sender {
    hours--;
    self.hoursLabel.text = [NSString stringWithFormat:@"%d hour", hours];
}

- (IBAction)incrementMinutes:(id)sender {
    minutes++;
    self.minutesLabel.text = [NSString stringWithFormat:@"%d minutes", minutes];
}

- (IBAction)decrementMinutes:(id)sender {
    minutes--;
    self.minutesLabel.text = [NSString stringWithFormat:@"%d minutes", minutes];
}
@end
