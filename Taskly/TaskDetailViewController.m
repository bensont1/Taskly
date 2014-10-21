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
    NSDate *createdAtDate = [self.task createdAt];
    int taskDurationInSeconds = [[self.task objectForKey:@"duration"] intValue];
    NSDate *expirationDate = [createdAtDate dateByAddingTimeInterval:taskDurationInSeconds];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitHour | NSCalendarUnitMinute
                                                        fromDate:createdAtDate
                                                          toDate:expirationDate
                                                         options:0];
    NSString *timeUntilExpiration = [NSString stringWithFormat:@"%ld hours and %ld minutes", [components hour], [components minute]];
    return timeUntilExpiration;
}

- (void)setMapViewLocation {
    NSString *locationText = [self.task objectForKey:@"location"];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:locationText completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        MKPlacemark *MKplacemark = [[MKPlacemark alloc] initWithPlacemark:placemark];
        MKCoordinateRegion region;
        region.center.latitude = placemark.region.center.latitude;
        region.center.longitude = placemark.region.center.longitude;
        MKCoordinateSpan span;
        double radius = placemark.region.radius / 1000; // convert to km
        span.latitudeDelta = radius / 112.0;
        region.span = span;
        [self.mapView setRegion:region animated:YES];
        [self.mapView addAnnotation:MKplacemark];
    }];
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
