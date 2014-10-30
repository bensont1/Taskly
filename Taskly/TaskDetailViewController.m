//
//  TaskDetailViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "TaskDetailViewController.h"
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

- (void)setFields {
    self.taskTitle.text = [self.task objectForKey:@"title"];
    self.taskDetails.text = [self.task objectForKey:@"details"];
    self.expirationlabel.text = [self getTimeToExpiration];
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", [self.task objectForKey:@"price"]];
    [self setMapViewLocation];
}

- (NSString *)getTimeToExpiration {
    NSDate *now = [NSDate date];
    NSDate *expirationDate = [self.task objectForKey:@"expirationDate"];

    //NSDate *expirationDate = [createdAtDate dateByAddingTimeInterval:taskDurationInSeconds];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitHour | NSCalendarUnitMinute
                                                        fromDate:now
                                                          toDate:expirationDate
                                                         options:0];
    NSString *timeUntilExpiration = [NSString stringWithFormat:@"%ld hours and %ld minutes", [components hour], [components minute]];
    return timeUntilExpiration;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//}

- (void)respondToTask {
    [self performSegueWithIdentifier:@"toRespondPage" sender:self];
}


@end
