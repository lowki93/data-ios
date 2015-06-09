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
#import "LoaderImageView.h"
#import "CustomButton.h"
#import "GroundImageView.h"

@interface GeolocViewController : UIViewController <CLLocationManagerDelegate>

/** location **/
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLGeocoder *geocoder;
@property (nonatomic) CLPlacemark *placemark;

/** pedometer **/
@property (nonatomic, strong) CMPedometer *pedometer;

@property (weak, nonatomic) IBOutlet LoaderImageView *loaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *synchroniseLabel;
@property (weak, nonatomic) IBOutlet UILabel *captaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *timeScrollView;
@property (weak, nonatomic) IBOutlet UILabel *learnLabel;
@property (weak, nonatomic) IBOutlet UIButton *touLabel;
@property (weak, nonatomic) IBOutlet CustomButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTitleView;

- (IBAction)nextAction:(id)sender;

@end