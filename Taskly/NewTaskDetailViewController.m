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
    //CLPlacemark *location;
    PFGeoPoint *location;
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

#warning TODO: Very messy, could use refactoring
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        CLLocation *placemarkLocation = placemark.location;
        CLLocationCoordinate2D coordinate = [placemarkLocation coordinate];
        
        location = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
        
        MKPlacemark *MKplacemark = [[MKPlacemark alloc] initWithPlacemark:placemark];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000);

        // remove all annotations
        NSMutableArray * annotationsToRemove = [ self.mapView.annotations mutableCopy ] ;
        [ annotationsToRemove removeObject:self.mapView.userLocation ] ;
        [ self.mapView removeAnnotations:annotationsToRemove ] ;
        
        [self.mapView addAnnotation:MKplacemark];
        [self.mapView setRegion:region animated:YES];
        
        //NSLog([self printLocationFromPlacemark:location]);
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
    //if(![self verifyAddress]) {
        //[self showInvalidLocationAlert];
    //}
    //else {
        self.task.location = location;
        [TaskManager addTask:self.task];
        [self showTaskAddedAlert];
        [self performSegueWithIdentifier:@"backToAddTaskMainView" sender:self];
    //}
}

//-(BOOL)verifyAddress {
//    //must have city and state
//    MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:];
//    if(location.locality == nil || location.administrativeArea == nil) {
//        return NO;
//    }
//    
//    //may not have street number without street name
//    if(location.subThoroughfare != nil) {
//        if(location.thoroughfare == nil) {
//            return NO;
//        }
//    }
//    
//    return YES;
//}

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
