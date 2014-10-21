//
//  NewTaskDetailViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "NewTaskDetailViewController.h"
#import "TaskManager.h"

@interface NewTaskDetailViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation NewTaskDetailViewController {
    CLPlacemark *location;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(addTask:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //@optional
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //@optional
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
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
        location = placemark;
        
        NSLog([self printLocationFromPlacemark:location]);
    }];
}

-(NSString*)printLocationFromPlacemark:(CLPlacemark*)placemark {
    NSString *locationString = [NSString stringWithFormat:@"%@ %@\n%@ %@ %@\n%@",
                   placemark.subThoroughfare, //street address #
                   placemark.thoroughfare, //street
                   placemark.locality, //city
                   placemark.administrativeArea, //state
                   placemark.postalCode, //zip code
                   placemark.country]; //country
    return locationString;
}

-(void)addTask:(UIButton *)sender {
    if(![self verifyAddress]) {
        [self showInvalidLocationAlert];
    }
    else {
        self.task.location = location;
        [TaskManager addTask:self.task];
        [self showTaskAddedAlert];
        //[self performSegueWithIdentifier:@"backToAddTaskMainView" sender:self];
    }
}

-(BOOL)verifyAddress {
    //must have city and state
    if(location.locality == nil || location.administrativeArea == nil) {
        return NO;
    }
    
    //may not have street number without street name
    if(location.subThoroughfare != nil) {
        if(location.thoroughfare == nil) {
            return NO;
        }
    }
    
    return YES;
}

-(void)showTaskAddedAlert {
    [[[UIAlertView alloc] initWithTitle:@"Task Added!"
                                message:@"Your task has been added successfully! Hopefully it will be filled soon."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

-(void)showInvalidLocationAlert {
    [[[UIAlertView alloc] initWithTitle:@"Invalid Location"
                                message:@"Please make sure you've entered a valid address. The minimum required information is city and state."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
