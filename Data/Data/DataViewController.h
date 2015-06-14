//
//  DataViewController.h
//  Data
//
//  Created by kevin Budain on 30/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineView.h"
#import "DataView.h"
#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <HealthKit/HealthKit.h>
#import "SSZipArchive.h"
@import CoreMotion;
@import AssetsLibrary;
#import "ProfileView.h"
#import "CreditView.h"

@interface DataViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic) UITapGestureRecognizer *closeInformationGesture;
@property (nonatomic) UITapGestureRecognizer *informationDataGesture;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet TimeLineView *timeLineView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet ProfileView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet CreditView *creditView;

/** location **/
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *location;
@property (nonatomic) CLLocation *lastLocation;
@property (nonatomic) CLGeocoder *geocoder;
@property (nonatomic) CLPlacemark *placemark;
@property (nonatomic) NSMutableDictionary *pedometerInformation;

@property (weak, nonatomic) IBOutlet UIButton *synchriButton;

/** pedometer **/
@property (nonatomic, strong) CMPedometer *pedometer;

/** background task **/
@property (nonatomic) UIApplication *app;
@property (nonatomic) UIBackgroundTaskIdentifier bgTask;

@property (nonatomic, assign) Experience *experience;

@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)showProfile:(id)sender;
- (IBAction)hideLogo:(id)sender;

- (IBAction)logoutAction:(id)sender;
- (IBAction)closeTimeLineAction:(id)sender;
- (void)uploadFile;

- (IBAction)removePlist:(id)sender;
- (IBAction)lauchSynchro:(id)sender;

@end