//
//  AccountTaskOwnDetailViewController.m
//  Taskly
//
//  Created by Benson Truong on 11/5/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "AccountTaskOwnDetailViewController.h"

@interface AccountTaskOwnDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *taskTitle;
@property (weak, nonatomic) IBOutlet UILabel *taskPosted;
@property (weak, nonatomic) IBOutlet UILabel *taskContact;
@property (weak, nonatomic) IBOutlet UITextView *taskDetails;
@property (weak, nonatomic) IBOutlet UILabel *finalOfferAmount;
- (IBAction)closeDetailView:(id)sender;

@end

@implementation AccountTaskOwnDetailViewController {
    PFObject *taskFillerDetails;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadOfferDetails];
    
    NSLog(@"OFFER DETAIL: %@", taskFillerDetails);
    
    // set labels on view
    self.taskTitle.text = [self.task objectForKey:@"title"];
    self.taskPosted.text = [self createDetailsString];
    
    self.taskContact.text = [taskFillerDetails objectForKey:@"contactInfo"];
    self.taskDetails.text = [taskFillerDetails objectForKey:@"additionalDetails"];
    

    NSNumber *amount = [taskFillerDetails objectForKey:@"amount"];

    NSString *formatedAmount = [NSString stringWithFormat:@"$%@.00", amount];
    self.finalOfferAmount.text = formatedAmount;
    
    
}

-(void)loadOfferDetails {
    PFRelation *relation = [self.task relationForKey:@"offered"];
    PFQuery *query = [relation query];
    [query whereKey:@"user" equalTo:self.taskFiller];
    taskFillerDetails = [query getFirstObject];
}

- (NSString *)createDetailsString {
    NSNumber *price = [self.task objectForKey:@"price"];
    NSDate *createdDate = [self.task createdAt];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/d/YYYY"];
    NSString *dateString = [dateFormat stringFromDate:createdDate];
    
    NSString *detailsString = [NSString stringWithFormat:@"You posted this task for $%@.00 on %@", price, dateString];
    return detailsString;
}

- (IBAction)closeDetailView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
