//
//  AccountViewController.m
//  Taskly
//
//  Created by Miles Laff on 11/2/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "AccountViewController.h"
#import <Parse/Parse.h>

@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UITableView *taskTable;

@end

@implementation AccountViewController {
    NSArray *ownedTasks;
    NSArray *fillingTasks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadOwnedTasks];
    [self loadFillingTasks];
}

- (void)loadOwnedTasks {
    int previousTaskCount = ownedTasks.count;
    
    if([PFUser currentUser] != nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"Tasks"];
        [query whereKey:@"owner" equalTo:[PFUser currentUser]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error) {
                ownedTasks = [NSArray arrayWithArray:objects];
                
                NSMutableArray *newIndexPaths = [NSMutableArray new];
                for(int i=previousTaskCount; i<ownedTasks.count; i++) {
                    [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                [self.taskTable insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

- (void)loadFillingTasks {
    int previousTaskCount = fillingTasks.count;
    
    if([PFUser currentUser] != nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"Offers"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error) {
                fillingTasks = [NSArray arrayWithArray:objects];
                
                NSMutableArray *newIndexPaths = [NSMutableArray new];
                for(int i=previousTaskCount; i<fillingTasks.count; i++) {
                    [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:1]];
                }
                [self.taskTable insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

#pragma mark - TableView Delegation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return ownedTasks.count;
    }
    else {
        return fillingTasks.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Tasks you own";
    }
    else {
        return @"Tasks you're filling";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"taskCell"];
    }
    
    if(indexPath.section == 0) {
        PFObject *task = [ownedTasks objectAtIndex:indexPath.row];
        cell.textLabel.text = [task objectForKey:@"title"];
        cell.detailTextLabel.text = [task objectForKey:@"details"];
    }
    else {
        PFObject *task = [fillingTasks objectAtIndex:indexPath.row];
        cell.textLabel.text = [task objectForKey:@"title"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"You offered to do this task for $%@.00", [task objectForKey:@"amount"]];
    }
    return cell;        
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
