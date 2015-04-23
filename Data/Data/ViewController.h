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
@import AssetsLibrary;
#import "SSZipArchive.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) CMPedometer *pedometer;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *synchronizeButton;
@property (weak, nonatomic) IBOutlet UILabel *synchroLabel;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (nonatomic) NSTimer *accuracyTimer;
@property (nonatomic) NSTimer *locationTimer;
@property (nonatomic) CLLocation *location;
@property (nonatomic) CLLocation *lastLocation;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSMutableDictionary *pedometerInformation;


- (IBAction)buttonPressed:(id)sender;
- (IBAction)logoutPressed:(id)sender;

@end