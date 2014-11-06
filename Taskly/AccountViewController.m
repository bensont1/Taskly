//
//  AccountViewController.m
//  Taskly
//
//  Created by Miles Laff on 11/2/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountTaskDetailViewController.h"
#import "AccountOfferDetailViewController.h"
#import "AccountTaskOwnDetailViewController.h"
#import <Parse/Parse.h>

@interface AccountViewController ()

@property (weak, nonatomic) IBOutlet UITableView *ownedTaskTable;
@property (weak, nonatomic) IBOutlet UITableView *fillingTaskTable;

@end

@implementation AccountViewController {
    NSMutableArray *ownedTasks;
    NSMutableArray *fillingTasks;
    PFObject *objectToSend;
    PFUser *fillerToSend;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadOwnedTasks];
    [self loadFillingTasks];
}

- (void)loadOwnedTasks {
    int previousTaskCount = (int)ownedTasks.count;
    
    if([PFUser currentUser] != nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"Tasks"];
        [query whereKey:@"owner" equalTo:[PFUser currentUser]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error) {
                ownedTasks = [NSMutableArray arrayWithArray:objects];
                
                NSMutableArray *newIndexPaths = [NSMutableArray new];
                for(int i=previousTaskCount; i<ownedTasks.count; i++) {
                    [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                [self.ownedTaskTable insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

- (void)loadFillingTasks {
    int previousTaskCount = (int) fillingTasks.count;
    
    if([PFUser currentUser] != nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"Offers"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error) {
                fillingTasks = [NSMutableArray arrayWithArray:objects];
                
                NSMutableArray *newIndexPaths = [NSMutableArray new];
                for(int i=previousTaskCount; i<fillingTasks.count; i++) {
                    [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                [self.fillingTaskTable insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

-(BOOL)checkTaskFiller {
    PFUser *fillerUser = [objectToSend objectForKey:@"filler"];
    if([[fillerUser valueForKey:@"objectId"] isEqualToString:@"JUTSUpXtKt"]) {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - TableView Delegation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.ownedTaskTable) {
        return ownedTasks.count;
    }
    else if(tableView == self.fillingTaskTable) {
        return fillingTasks.count;
    }
    else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == self.ownedTaskTable) {
        return @"Tasks You Own";
    }
    else if(tableView == self.fillingTaskTable) {
        return @"Tasks You've Offered To Fill";
    }
    else {
        return @"Invalid Section";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.ownedTaskTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ownedTaskCell" forIndexPath:indexPath];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ownedTaskCell"];
        }
        
        PFObject *task = [ownedTasks objectAtIndex:indexPath.row];
        cell.textLabel.text = [task objectForKey:@"title"];
        cell.detailTextLabel.text = [task objectForKey:@"details"];
        return cell;
    }
    else if(tableView == self.fillingTaskTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fillingTaskCell" forIndexPath:indexPath];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"fillingTaskCell"];
        }
        
        PFObject *offer = [fillingTasks objectAtIndex:indexPath.row];
        cell.textLabel.text = [offer objectForKey:@"title"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"You offered to do this task for $%@.00", [offer objectForKey:@"amount"]];
        return cell;
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.ownedTaskTable) {
        PFObject *task = [ownedTasks objectAtIndex:indexPath.row];
        objectToSend = task;
        if(![self checkTaskFiller]) {
            [self performSegueWithIdentifier:@"toTaskDetails" sender:self];
        }
        else {
            fillerToSend = [objectToSend objectForKey:@"filler"];
            [self performSegueWithIdentifier:@"toFilledTask" sender:self];
        }
        [self.ownedTaskTable deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    else if(tableView == self.fillingTaskTable) {
        PFObject *offer = [fillingTasks objectAtIndex:indexPath.row];
        objectToSend = offer;
        [self performSegueWithIdentifier:@"toOfferDetails" sender:self];
        
        [self.fillingTaskTable deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    else {
        NSLog(@"Error: Invalid TableView");
    }

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code to delete
        if(tableView == self.fillingTaskTable){
            PFQuery *query = [PFQuery queryWithClassName:@"Offers"];
            NSString *objectId = [fillingTasks[indexPath.row]valueForKey:@"objectId"];
            [query whereKey:@"objectId" equalTo:objectId];
            PFObject *deletedObject = [query getFirstObject];
            if(deletedObject){
                [deletedObject deleteInBackground];
                [fillingTasks removeObjectAtIndex:[indexPath row]];
                [self.fillingTaskTable reloadData];
            }
        }
        else if(tableView == self.ownedTaskTable){
            PFQuery *query = [PFQuery queryWithClassName:@"Tasks"];
            NSString *objectId = [ownedTasks[indexPath.row]valueForKey:@"objectId"];
            [query whereKey:@"objectId" equalTo:objectId];
            PFObject *deletedObject = [query getFirstObject];
            if(deletedObject){
                [deletedObject deleteInBackground];
                [ownedTasks removeObjectAtIndex:indexPath.row];
                [self.ownedTaskTable reloadData];
            }
        }
        
        
        
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[AccountTaskDetailViewController class]]) {
        AccountTaskDetailViewController *destination = segue.destinationViewController;
        destination.task = objectToSend;
    }
    else if([segue.destinationViewController isKindOfClass:[AccountOfferDetailViewController class]]) {
        AccountOfferDetailViewController *destination = segue.destinationViewController;
        destination.offer = objectToSend;
    }
    else if([segue.destinationViewController isKindOfClass:[AccountTaskOwnDetailViewController class]]) {
        AccountTaskOwnDetailViewController *destination = segue.destinationViewController;
        destination.task = objectToSend;
        destination.taskFiller = fillerToSend;
    }
}


@end
