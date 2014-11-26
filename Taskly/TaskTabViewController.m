//
//  TaskTabViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/13/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "TaskTabViewController.h"
#import "TaskDetailViewController.h"
#import "TaskManager.h"
#import "Task.h"
#import "MainTaskPageCell.h"
#import "Utilities.h"

@interface TaskTabViewController ()

@end

@implementation TaskTabViewController {
    NSMutableArray *tasks;
    PFObject *selectedTask;
    NSString *titleTextKey;
    NSString *detailTextKey;
    NSString *priceTextKey;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(5.0f, 0.0f, 0.0f, 0.0f);
    //self.automaticallyAdjustsScrollViewInsets = NO; //removes weird space above first cell
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Tasks";
        
        titleTextKey = @"title";
        detailTextKey = @"details";
        priceTextKey = @"price";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}


#pragma mark - Parse Implementation

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"public_profile", @"email", nil]];
        [logInViewController setFields: PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton |
         PFLogInFieldsFacebook | PFLogInFieldsSignUpButton];
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"User Success login: %@", user);
    
    // set Facebook data to parse
    // After logging in with Facebook
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            NSString *facebookName = [result objectForKey:@"name"];
            NSString *facebookId = [result objectForKey:@"id"];
            [[PFUser currentUser] setObject:facebookId forKey:@"facebookId"];
            [[PFUser currentUser] setObject:facebookName forKey:@"fullName"];
            [[PFUser currentUser] saveEventually];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

#pragma mark - TableViewDelegation

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *cellId = @"taskCell";
    MainTaskPageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        cell = [[MainTaskPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.cellTitle.text = [object objectForKey:titleTextKey];
    cell.cellDetails.text = [object objectForKey:detailTextKey];
    cell.cellPrice.text = [NSString stringWithFormat:@"$%@", [object objectForKey:priceTextKey]];
    
    UIImage *picture = [UIImage imageNamed:@"placeholder_image.png"];
    
    NSString *facebookId = [[object objectForKey:@"owner"] objectForKey:@"facebookId"];

    if(facebookId != nil) {
       /*
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:@"facebookId"]]];
        NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
        [NSURLConnection sendAsynchronousRequest:profilePictureURLRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data,
                                                   NSError *connectionError) {
                                   UIImage *profile = [UIImage imageWithData:data];
                                   [cell.profImage setImage:[Utilities getRoundedRectImageFromImage:profile onReferenceView:self.profImage withCornerRadius:self.profImage.frame.size.width/2]];
                               }];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:profilePictureURLRequest delegate:self];
        */
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", facebookId]];
        NSData * data = [NSData dataWithContentsOfURL:profilePictureURL];
        picture = [UIImage imageWithData:data];
    }
    
    NSLog(@"Getting picture");
    [cell.profImage setImage:[Utilities getRoundedRectImageFromImage:picture onReferenceView:cell.profImage withCornerRadius:cell.profImage.frame.size.width/2]];


    //[cell.profImage setImage:picture];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedTask = [self.objects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segueToTaskDetail" sender:self];
}

//only get tasks that are not filled and haven't expired
-(PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query includeKey:@"owner"];
    if([PFUser currentUser]) {
        [query whereKey:@"completed" equalTo:[NSNumber numberWithBool:NO]];
        //[query whereKey:@"owner" notEqualTo:[PFUser currentUser]];
        
        NSDate *now = [NSDate date];
        [query whereKey:@"expirationDate" greaterThan:now];
    }
    return query;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TaskDetailViewController *destination = segue.destinationViewController;
    destination.task = selectedTask;
}

@end
