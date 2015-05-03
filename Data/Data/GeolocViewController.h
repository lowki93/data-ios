//
//  GeolocViewController.h
//  Data
//
//  Created by kevin Budain on 30/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <HealthKit/HealthKit.h>
@import CoreMotion;
@import AssetsLibrary;
#import "SSZipArchive.h"

@interface GeolocViewController : UIViewController <CLLocationManagerDelegate>

/** location **/
@property (nonatomic) CLLocationManager *locationManager;

/** pedometer **/
@property (nonatomic, strong) CMPedometer *pedometer;

@property (weak, nonatomic) IBOutlet UIImageView *loaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *synchroniseLabel;
@property (weak, nonatomic) IBOutlet UILabel *captaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *timeScrollView;

@end