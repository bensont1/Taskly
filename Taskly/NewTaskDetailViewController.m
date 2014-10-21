//
//  NewTaskDetailViewController.m
//  Taskly
//
//  Created by Miles Laff on 10/20/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "NewTaskDetailViewController.h"

@interface NewTaskDetailViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation NewTaskDetailViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addTaskButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(addTask:)];
    self.navigationItem.rightBarButtonItem = addTaskButton;
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
        MKCoordinateRegion region;
        region.center.latitude = placemark.region.center.latitude;
        region.center.longitude = placemark.region.center.longitude;
        MKCoordinateSpan span;
        double radius = placemark.region.radius / 1000; // convert to km
        
        NSLog(@"[searchBarSearchButtonClicked] Radius is %f", radius);
        span.latitudeDelta = radius / 112.0;
        
        region.span = span;
        
        [self.mapView setRegion:region animated:YES];
    }];
}

@end
