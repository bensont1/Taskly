//
//  NewTaskDetailViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "NewTaskDetailViewController.h"
#import "NewTaskViewController.h"
#import "TaskManager.h"

@interface NewTaskDetailViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation NewTaskDetailViewController {
    CLLocationManager *locationManager;
    CLLocation *currentUserLocation;
    PFGeoPoint *location;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(addTask:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *currentLocationButton = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage imageNamed:@"pin_icon.png"]
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(zoomToCurrentLocation)];
    self.navigationItem.leftBarButtonItem = currentLocationButton;
}

- (void)zoomToCurrentLocation {
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(currentUserLocation.coordinate.latitude, currentUserLocation.coordinate.longitude);
    MKPlacemark *marker = [[MKPlacemark alloc] initWithCoordinate:coord addressDictionary:nil];
    
    // center map
    [self.mapView setRegion:MKCoordinateRegionMake(coord,MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    [self.mapView addAnnotation:marker];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *myLocation = [locations lastObject];
    currentUserLocation = myLocation;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //@optional
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //@optional
}

#warning TODO: Very messy, could use refactoring
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

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)addTask:(UIButton *)sender {
    //if(![self verifyAddress]) {
        //[self showInvalidLocationAlert];
    //}
    //else {
        self.task.location = location;
        [TaskManager addTask:self.task];
        [self showTaskAddedAlert];
        //[self performSegueWithIdentifier:@"backToAddTaskMainView" sender:self];
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

-(void)resetFields {
    // reset map
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.centerCoordinate, MKCoordinateSpanMake(180, 360));
    [self.mapView setRegion:region animated:YES];
    
    // remove all annotations
    NSMutableArray * annotationsToRemove = [ self.mapView.annotations mutableCopy ] ;
    [ annotationsToRemove removeObject:self.mapView.userLocation ] ;
    [ self.mapView removeAnnotations:annotationsToRemove ] ;
    
    // reset search bar
    self.searchBar.text = @"";
}

-(void)showTaskAddedAlert {
    UIAlertView *taskAddedSuccessAlert = [[UIAlertView alloc] initWithTitle:@"Task Added!"
                                message:@"Your task has been added successfully! Hopefully it will be filled soon."
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil];
    [taskAddedSuccessAlert setTag:1];
    [taskAddedSuccessAlert show];
}

-(void)showInvalidLocationAlert {
    [[[UIAlertView alloc] initWithTitle:@"Invalid Location"
                                message:@"Please make sure you've entered a valid address. The minimum required information is city and state."
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1) {
        if(buttonIndex == [alertView cancelButtonIndex]) {
            [self.parentViewController.tabBarController setSelectedIndex:0];
            [self resetFields];
        }
    }
}

@end
