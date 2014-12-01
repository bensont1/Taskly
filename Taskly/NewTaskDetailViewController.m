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

- (IBAction)zoomToCurrentLocation:(id)sender;

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
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *myLocation = [locations lastObject];
    currentUserLocation = myLocation;
}


#pragma mark - SearchBar Delegation

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
        CLLocation *placemarkLocation = placemark.location;
        CLLocationCoordinate2D coordinate = [placemarkLocation coordinate];
        
        location = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        
        MKPlacemark *MKplacemark = [[MKPlacemark alloc] initWithPlacemark:placemark];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000);

        // remove all annotations
        NSMutableArray * annotationsToRemove = [ self.mapView.annotations mutableCopy ] ;
        [ annotationsToRemove removeObject:self.mapView.userLocation ] ;
        [ self.mapView removeAnnotations:annotationsToRemove ] ;
        
        [self.mapView addAnnotation:MKplacemark];
        [self.mapView setRegion:region animated:YES];
    }];
}

- (IBAction)zoomToCurrentLocation:(id)sender {
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(currentUserLocation.coordinate.latitude, currentUserLocation.coordinate.longitude);
    MKPlacemark *marker = [[MKPlacemark alloc] initWithCoordinate:coord addressDictionary:nil];
    
    [self.mapView setRegion:MKCoordinateRegionMake(coord,MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    [self.mapView addAnnotation:marker];
    
    location = [PFGeoPoint geoPointWithLatitude:coord.latitude longitude:coord.longitude];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)addTask:(UIButton *)sender {
    if(location != nil) {
        self.task.location = location;
        [TaskManager addTask:self.task];
        [self showTaskAddedAlert];
    }
    
    else {
        [self showNoLocationAlert];
    }
    
}

-(void)resetFields {
    // reset map
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.centerCoordinate, MKCoordinateSpanMake(180, 360));
    [self.mapView setRegion:region animated:YES];
    
    // remove all annotations
    NSMutableArray * annotationsToRemove = [ self.mapView.annotations mutableCopy ] ;
    [ annotationsToRemove removeObject:self.mapView.userLocation ] ;
    [ self.mapView removeAnnotations:annotationsToRemove ] ;
    
    // reset search bar text
    self.searchBar.text = @"";
}


#pragma mark - Alerts

-(void)showTaskAddedAlert {
    UIAlertView *taskAddedSuccessAlert = [[UIAlertView alloc] initWithTitle:@"Task Added!"
                                message:@"Your task has been added successfully! Hopefully it will be filled soon."
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil];
    [taskAddedSuccessAlert setTag:1];
    [taskAddedSuccessAlert show];
}

-(void)showNoLocationAlert {
    [[[UIAlertView alloc] initWithTitle:@"No Location Selected"
                                message:@"Please make sure you've chosen a location so people will know to respond!"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1) {
        if(buttonIndex == [alertView cancelButtonIndex]) {
            [self resetFields];
            [self.taskNewController performSelector:@selector(resetFields)];
            [self.tabBarController setSelectedIndex:0];
        }
    }
}
@end
