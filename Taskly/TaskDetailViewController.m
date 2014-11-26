//
//  TaskDetailViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "RespondToTaskViewController.h"
#import <MapKit/MapKit.h>

@interface TaskDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *taskTitle;
@property (weak, nonatomic) IBOutlet UITextView *taskDetails;
@property (weak, nonatomic) IBOutlet UILabel *expirationlabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *respondButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Respond"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                      action:@selector(respondToTask)];
    self.navigationItem.rightBarButtonItem = respondButton;
    
    [self setFields];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)setFields {
    [self getTimeToExpiration];
    self.taskTitle.text = [self.task objectForKey:@"title"];
    self.taskDetails.text = [self.task objectForKey:@"details"];
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", [self.task objectForKey:@"price"]];
    [self setMapViewLocation];
}

- (void)getTimeToExpiration {
        //Set up a timer that calls the updateTime method every second to update the label
        NSTimer *timer;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(updateTime)
                                               userInfo:nil
                                                repeats:YES];
}

-(void)updateTime
{
    NSDate *expirationDate = [self.task objectForKey:@"expirationDate"];
    //Get the time left until the specified date
    NSInteger ti = ((NSInteger)[expirationDate timeIntervalSinceNow]);
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600) % 24;
    NSInteger days = (ti / 86400);
    
    //Update the label with the remaining time
    self.expirationlabel.text = [NSString stringWithFormat:@"%02li hrs %02li min %02li sec", (long)hours, (long)minutes, (long)seconds];
}

- (void)setMapViewLocation {
    //NSString *locationText = [self.task objectForKey:@"location"];
    
    PFGeoPoint *locationFromParse = [self.task objectForKey:@"location"];
    
    // create annotation to add
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(locationFromParse.latitude, locationFromParse.longitude);
    MKPlacemark *marker = [[MKPlacemark alloc] initWithCoordinate:coord addressDictionary:nil];
    
    // center map
    [self.mapView setRegion:MKCoordinateRegionMake(coord,MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    [self.mapView addAnnotation:marker];
}

- (void)respondToTask {
    if([self userOwnsTask]) {
        [self showUserOwnsTaskAlert];
    }
    else {
        [self performSegueWithIdentifier:@"toRespondPage" sender:self];
    }
}

- (BOOL)userOwnsTask {
    PFUser *taskOwner = [self.task objectForKey:@"owner"];
    NSString *taskOwnerID = [taskOwner objectId];
    NSString *currentUserID = [[PFUser currentUser] objectId];
    if([taskOwnerID isEqualToString:currentUserID]) {
        return YES;
    }
    else {
        return NO;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RespondToTaskViewController *destination = segue.destinationViewController;
    destination.task = self.task;
}


#pragma mark - Alerts

-(void)showUserOwnsTaskAlert {
    UIAlertView *contactInfoErrorAlert = [[UIAlertView alloc] initWithTitle:@"This is your task!"
                                                                    message:@"You can't fill your own task, give someone else a chance!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
    [contactInfoErrorAlert setTag:0];
    [contactInfoErrorAlert show];
}

@end
