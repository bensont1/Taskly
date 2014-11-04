//
//  AccountTaskDetailViewController.m
//  Taskly
//
//  Created by Miles Laff on 11/3/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "AccountTaskDetailViewController.h"

@interface AccountTaskDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskDetailsLabel;
@property (weak, nonatomic) IBOutlet UITableView *offerTable;

@end

@implementation AccountTaskDetailViewController {
    NSArray *offers;
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
    int previousOfferCount = offers.count;
    
    if([PFUser currentUser] != nil) {
        PFRelation *relation = [self.task relationForKey:@"offered"];
        PFQuery *query = [relation query];
        
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
    cell.textLabel.text = [offer objectForKey:@"title"];
    
    NSNumber *amountOffered = [offer objectForKey:@"amount"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"This user will complete your task for $%@.00", amountOffered];
    return cell;
}




@end
