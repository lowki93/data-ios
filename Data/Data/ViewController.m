//
//  ViewController.m
//  Data
//
//  Created by kevin Budain on 03/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) CLLocationCoordinate2D userLocation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // FOR GEOLOCALIZATION
    locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled] ) {
        [locationManager setDelegate: self];
        [locationManager setDesiredAccuracy: kCLLocationAccuracyBest];
        [locationManager setDistanceFilter: 100.f];
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] ) {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CLLocationDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSLog(@"latitude : %f, longitude : %f", location.coordinate.latitude, location.coordinate.longitude);
    
}

@end
