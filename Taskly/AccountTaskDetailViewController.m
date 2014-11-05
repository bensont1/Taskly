//
//  AccountTaskDetailViewController.m
//  Taskly
//
//  Created by Miles Laff on 11/3/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "AccountTaskDetailViewController.h"
#import "TaskManager.h"

@interface AccountTaskDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDetailsLabel;
@property (weak, nonatomic) IBOutlet UITableView *offerTable;

@end

@implementation AccountTaskDetailViewController {
    NSArray *offers;
    int selected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    //offers = [[NSArray alloc] init];
    self.taskTitleLabel.text = [self.task objectForKey:@"title"];
    self.taskDetailsLabel.text = [self createDetailsString];
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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadOffers];
}

- (void)loadOffers {
    int previousOfferCount = (int) offers.count;
    
    if([PFUser currentUser] != nil) {
        PFRelation *relation = [self.task relationForKey:@"offered"];
        PFQuery *query = [relation query];
        [query includeKey:@"user"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error) {
                offers = [NSArray arrayWithArray:objects];
                
                NSMutableArray *newIndexPaths = [NSMutableArray new];
                for(int i=previousOfferCount; i<offers.count; i++) {
                    [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                [self.offerTable insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != [alertView cancelButtonIndex]) {
        NSLog(@"OBJECT AT INDEX %d, %@", selected, offers[selected]);
        NSLog(@"FOR TASK: %@", self.task);
        
        PFObject *offer = offers[selected];
        PFUser *userOfOffer = [offer objectForKey:@"user"];
        
        [TaskManager acceptFiller:self.task withUser:userOfOffer];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark TABLEVIEW

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Offers To Complete This Task";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return offers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"offerCell"];
    }
    
    PFObject *offer = [offers objectAtIndex:indexPath.row];
    PFUser *userOfOffer = [offer objectForKey:@"user"];
    NSString *nameToDisplay = [userOfOffer objectForKey:@"fullName"];
    
    if(!nameToDisplay) {
        nameToDisplay = [userOfOffer objectForKey:@"username"];
    }

    cell.textLabel.text = nameToDisplay;
    
    NSNumber *amountOffered = [offer objectForKey:@"amount"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"This user will complete your task for $%@.00", amountOffered];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *offer = [offers objectAtIndex:indexPath.row];
    PFUser *userOfOffer = [offer objectForKey:@"user"];
    NSString *nameToDisplay = [userOfOffer objectForKey:@"fullName"];

    if(!nameToDisplay) {
        nameToDisplay = [userOfOffer objectForKey:@"username"];
    }
    NSString *offerMessage = [NSString stringWithFormat:@"You have selected %@ to complete your task. Do you wish to accept this offer?", nameToDisplay];
    UIAlertView *selectRow = [[UIAlertView alloc] initWithTitle:@"Selected Offer" message:offerMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Accept", nil];
    
    [selectRow show];
    
    selected = (int) indexPath.row;
    NSLog(@"%ld", (long)indexPath.row);
}






@end
