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
//    locationManager = [[CLLocationManager alloc] init];
//    if ([CLLocationManager locationServicesEnabled] ) {
//        [locationManager setDelegate: self];
//        [locationManager setDesiredAccuracy: kCLLocationAccuracyBest];
//        [locationManager setDistanceFilter: 100.f];
//        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] ) {
//            [locationManager requestWhenInUseAuthorization];
//        }
//        [locationManager startUpdatingLocation];
//    }
    
    // FOR PODOMETER
//    if ([CMPedometer isStepCountingAvailable]) {
//        self.pedometer = [[CMPedometer alloc] init];
//    }
//    
//    NSDate *to = [NSDate date];
//    float time = 3;
//    NSDate *from = [to dateByAddingTimeInterval:-(1. * time * 3600)];
//    [self queryDataFrom:from toDate:to];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.pedometer stopPedometerUpdates];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.pedometer startPedometerUpdatesFromDate:[NSDate date]
                                      withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                          });
                                      }];
}

#pragma mark - CLLocationDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSLog(@"latitude : %f, longitude : %f", location.coordinate.latitude, location.coordinate.longitude);
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");
}

- (NSString *)stringWithObject:(id)obj {
    return [NSString stringWithFormat:@"%@", obj];
}

- (NSString *)stringForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [formatter stringFromDate:date];
}

- (void)queryDataFrom:(NSDate *)startDate toDate:(NSDate *)endDate {
    [self.pedometer queryPedometerDataFromDate:startDate
                                        toDate:endDate
                                   withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (error) {
                                               NSLog(@"error");
                                           } else {
                                               NSLog(@"steps : %@",pedometerData.numberOfSteps);
                                               NSLog(@"distance : %@", [NSString stringWithFormat:@"%f.1[m]", [pedometerData.distance floatValue]]);
                                           }
                                       });
                                   }];
}

- (IBAction)buttonPressed:(id)sender {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    [localNotification setAlertBody:@"sa marche"];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end