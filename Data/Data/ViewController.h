//
//  ViewController.h
//  Data
//
//  Created by kevin Budain on 03/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <HealthKit/HealthKit.h>
@import CoreMotion;

@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) CMPedometer *pedometer;

- (IBAction)buttonPressed:(id)sender;

@end