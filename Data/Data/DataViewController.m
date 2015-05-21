//
//  DataViewController.m
//  Data
//
//  Created by kevin Budain on 30/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "DataViewController.h"
#import "AFURLSessionManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface DataViewController ()

@end

BaseViewController *baseView;

NSDictionary *dictionary;

/** dataView **/
NSMutableArray *dateArray;
NSMutableArray *dataViewArray;;
int nbDay, margin, indexDay = 0, positionTop, heigtViewDetail;
float firstScale,secondScale, upScale, downScale, transition, translationDate;

/** synchro **/
int timeSynchro;
bool activeSyncho;

/** gesture **/
UISwipeGestureRecognizer *leftGesture, *rightGesture, *upGesture;
UITapGestureRecognizer *closeGesture, *closeAllInformationDataGesture;

/** location **/
NSString *filePath;
NSMutableArray *logText;
NSMutableArray *logArray;
NSString *newTextLog;
NSTimer *timerLocation;

/** pedometer **/
NSDate *startDate, *endDate;
float distance;

@implementation DataViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    if(self.experience) {
        NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"];
        [[ApiController sharedInstance] setUserLoad:dictionary];
    }

    for (UIView *subView in self.contentScrollView.subviews)
    {
        [subView removeFromSuperview];
    }

    /** format date **/
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString: [ApiController sharedInstance].experience.startDate];
    NSDate *endDate = [dateFormatter dateFromString: [ApiController sharedInstance].experience.endDate];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                               fromDate:startDate
                                                 toDate:endDate
                                                options:0];

    nbDay = (int)components.day;
    indexDay = 0;
    margin = 50;
    firstScale = 0.8;
    secondScale = 0.5;
    downScale = 0.7;
    upScale = 1.5;
    positionTop = self.view.bounds.size.height * 0.30;
    heigtViewDetail = self.view.bounds.size.height * 0.70;
    transition = 20;
    translationDate = 20;

    [self.topConstraint setConstant:self.view.bounds.size.height * 0.10];
    dateArray = [[NSMutableArray alloc] init];
    dataViewArray = [[NSMutableArray alloc] init];

    /** TIMELINE **/
    [self.timeLineView setBackgroundColor:[UIColor clearColor]];
    [self.timeLineView initTimeLine:nbDay indexDay:indexDay];
    [self.timeLineView setHidden:YES];
    [self animateTimeLine:upScale Alpha:0];

    /** dataView by day **/
    [self.contentScrollView setPagingEnabled:YES];
    [self.contentScrollView setContentSize:CGSizeMake(((self.view.bounds.size.width + margin) * nbDay), self.view.bounds.size.height)];
    [self.contentScrollView setBackgroundColor:[UIColor clearColor]];
    [self.contentScrollView setShowsHorizontalScrollIndicator:NO];
    [self.contentScrollView setShowsVerticalScrollIndicator:NO];
    [self.contentScrollView setScrollsToTop:NO];
    [self.contentScrollView setAlpha:0];

    for (int i = 0; i < nbDay; i++) {

        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[baseView colorWithRGB:243 :243 :243 :1]];
        [view setFrame:CGRectMake((self.view.bounds.size.width + margin) * i, positionTop, self.view.bounds.size.width ,heigtViewDetail )];

        DataView *dataView = [[DataView alloc] init];
        [dataView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, heigtViewDetail)];
        [dataView initView:self];
        [dataView drawData:i];
        [dataView setTag:i];
        [view addSubview:dataView];

        /** format date **/
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [dateFormatter dateFromString: [ApiController sharedInstance].experience.startDate];
        NSDate *endDate = [startDate dateByAddingTimeInterval:+(1. * i * 86400)];

        if([[[ApiController sharedInstance] getDate] isEqualToString:[NSString stringWithFormat:@"%@", endDate]]) {
            indexDay = i;
            NSLog(@"%i", i);
        }

        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init] ;
        [dayFormatter setDateFormat:@"EEEE dd"];
        [dayFormatter setLocale:usLocale];

        NSString *week = [dayFormatter stringFromDate:endDate];
        [dateArray addObject:week];
        [dataViewArray addObject:dataView];

        [self.contentScrollView addSubview:view];
    }

    [self.dateLabel setText:[dateArray objectAtIndex:indexDay]];
    [self updateInformationLabel];
    [self animatedView:self.dateLabel Duration:0 Delay:0 Alpha:0 Translaton:translationDate];
    [self animatedView:self.informationLabel Duration:0 Delay:0 Alpha:0 Translaton:translationDate];

    CGRect frame = self.contentScrollView.frame;
    frame.origin.x = (self.view.bounds.size.width + margin ) * indexDay;
    [self.contentScrollView scrollRectToVisible:frame animated:NO];

    [self.view sendSubviewToBack:self.contentScrollView];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    /** Gesture **/
    leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [leftGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];

    rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [rightGesture setDirection:(UISwipeGestureRecognizerDirectionLeft)];

    upGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    [upGesture setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.view addGestureRecognizer:upGesture];

    closeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];

    self.informationDataGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(informationData:)];
    [self.view addGestureRecognizer:self.informationDataGesture];

    closeAllInformationDataGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAllInformationData:)];

    self.closeInformationGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeInformationData:)];

    /** for location **/
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    filePath = [documentsDirectory stringByAppendingPathComponent:@"geolocation.plist"];

    self.geocoder = [[CLGeocoder alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled] ) {

        [self.locationManager  setDelegate: self];
        [self.locationManager  setDesiredAccuracy: kCLLocationAccuracyThreeKilometers];
        [self.locationManager  setDistanceFilter: 9999];

        if ([self.locationManager  respondsToSelector:@selector(requestAlwaysAuthorization)] ) {

            [self.locationManager  requestAlwaysAuthorization];
            [self.locationManager startUpdatingLocation];

        }
    }

    [self animatedUpScrollView:0 First:YES];
    [self performSelector:@selector(animatedCloseScrollView) withObject:nil afterDelay:0.5];

    [self animatedView:self.dateLabel Duration:0.5 Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.informationLabel Duration:0.5 Delay:0.2 Alpha:1 Translaton:0];

    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        [self.contentScrollView setAlpha:1];

    } completion:nil ];

    /** time synchro : hour **/
    timeSynchro = 1;
    [self updateDate];

}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    
}

/** date method  **/
- (void)updateDate {
    NSDate *now = [[NSDate alloc] init];
    startDate = now;
    endDate = [startDate dateByAddingTimeInterval:-(1. * timeSynchro * 3600)];
    
}

/** pedometer method **/
- (void)queryPedometerDataFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    [self.pedometer queryPedometerDataFromDate:startDate
                                        toDate:endDate
                                   withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (error) {
                                               NSLog(@"%@", error);
                                           } else {
                                               self.pedometerInformation = [[NSMutableDictionary alloc]init];
                                               distance = [pedometerData.distance floatValue];
                                               [self.pedometerInformation setObject:[NSNumber numberWithInt:[pedometerData.numberOfSteps intValue]] forKey:@"stepNumber"];
                                               [self.pedometerInformation setObject:[NSNumber numberWithFloat:distance] forKey:@"distance"];
                                               [self.pedometerInformation setObject:[NSNumber numberWithFloat:(distance / 1000 / timeSynchro)] forKey:@"vitesse"];
                                               [self updateData];
                                           }
                                       });
                                   }];
}

/** location method **/
- (void)locationManager:(CLLocationManager *)lm didUpdateLocations:(NSArray *)locations {

    [self.locationManager stopMonitoringForRegion:nil];
    [self.locationManager stopUpdatingLocation];
    NSLog(@"update location");
    self.location = [locations lastObject];

    NSLog(@"speed %.1f km/h", self.location.speed * 3.6);
    [self sendLocalNotification:[NSString stringWithFormat:@"speed %.1f km/h", self.location.speed * 3.6]];

    [lm setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    [lm setDistanceFilter:99999];

    float speed =  self.location.speed * 3.6;
    CLCircularRegion *region;

    if (speed < 10) {
        NSLog(@"1000");

        region= [[CLCircularRegion alloc] initWithCenter:[self.location coordinate]
                                                                     radius:1000
                                                                 identifier:[[NSUUID UUID] UUIDString]];

    } else if (speed < 50) {

        region = [[CLCircularRegion alloc] initWithCenter:[self.location coordinate]
                                                                     radius:10000
                                                                 identifier:[[NSUUID UUID] UUIDString]];
        NSLog(@"10000");

    } else if (speed < 100) {

        region = [[CLCircularRegion alloc] initWithCenter:[self.location coordinate]
                                                                     radius:25000
                                                                 identifier:[[NSUUID UUID] UUIDString]];
        NSLog(@"25000");

    } else if (speed < 180) {

        NSLog(@"50000");
        region = [[CLCircularRegion alloc] initWithCenter:[self.location coordinate]
                                                                     radius:50000
                                                                 identifier:[[NSUUID UUID] UUIDString]];

    } else {

        NSLog(@"more than 180");
        region = [[CLCircularRegion alloc] initWithCenter:[self.location coordinate]
                                                   radius:800000
                                               identifier:[[NSUUID UUID] UUIDString]];

    }

    NSMutableDictionary *myBestLocation = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *addressLocation = [[NSMutableDictionary alloc] init];

    /** add location and distance **/
    [myBestLocation setObject:[NSNumber numberWithFloat:self.location.coordinate.latitude] forKey:@"latitude"];
    [myBestLocation setObject:[NSNumber numberWithFloat:self.location.coordinate.longitude] forKey:@"longitude"];
    [myBestLocation setObject:[NSNumber numberWithFloat:[self.lastLocation distanceFromLocation:self.location]] forKey:@"distance"];
    NSLog(@"%f", [self.lastLocation distanceFromLocation:self.location]);

    [self.geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            /** address location **/
            [addressLocation setObject:[NSString stringWithFormat:@"%@", self.placemark.subThoroughfare] forKey:@"numbers"];
            [addressLocation setObject:[NSString stringWithFormat:@"%@", self.placemark.thoroughfare] forKey:@"way"];
            [addressLocation setObject:[NSString stringWithFormat:@"%@", self.placemark.postalCode] forKey:@"postalCode"];
            [addressLocation setObject:[NSString stringWithFormat:@"%@", self.placemark.locality] forKey:@"town"];
            [addressLocation setObject:[NSString stringWithFormat:@"%@", self.placemark.administrativeArea] forKey:@"area"];
            [addressLocation setObject:[NSString stringWithFormat:@"%@", self.placemark.country] forKey:@"country"];
            /** add to myBestLocation **/
            [myBestLocation setObject:addressLocation forKey:@"address"];
            [self saveLocation:myBestLocation];

        } else {

            [myBestLocation setObject:addressLocation forKey:@"address"];
            [self saveLocation:myBestLocation];

        }
        self.lastLocation = self.location;
    }];

    [self.locationManager startMonitoringForRegion:(CLRegion *)region];

}

- (void)saveLocation:(NSMutableDictionary *)myBestLocation {

    [myBestLocation setObject:[NSString stringWithFormat:@"%@", [[ApiController sharedInstance] getDateWithTime]] forKey:@"time"];
    [self writeIntoPlist:myBestLocation];

}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {

    NSLog(@"enter region");
    [self sendLocalNotification:@"new region"];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {

    NSLog(@"end region");
    [self sendLocalNotification:@"end region"];
    [self.locationManager startUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {

    NSLog(@"start region");
    [timerLocation invalidate];
    [self sendLocalNotification:@"start region"];
    // 10min : 600 // 30min : 1800
    timerLocation = [NSTimer scheduledTimerWithTimeInterval:1800.
                                                          target:self
                                                        selector:@selector(startLocation)
                                                        userInfo:nil
                                                         repeats:NO];

}

/** notification method **/
- (void)sendLocalNotification:(NSString *)string {

    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    [localNotification setAlertBody:[NSString stringWithFormat:@"%@", string]];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

}

- (void)writeIntoPlist:(NSMutableDictionary *)mutableDictionary {

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {

        NSMutableArray *geolocMutableArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        [geolocMutableArray addObject:mutableDictionary];
        [geolocMutableArray writeToFile:filePath atomically:YES];

    } else {

        NSMutableArray *geolocMutableArray = [[NSMutableArray alloc] init];
        [geolocMutableArray addObject:mutableDictionary];
        [geolocMutableArray writeToFile:filePath atomically:YES];

    }

}

- (NSMutableArray *)contenPlist {

    NSMutableArray *contenPlist = [NSMutableArray arrayWithContentsOfFile:filePath];
    return contenPlist;

}

- (void)startLocation {

    [self sendLocalNotification:@"stay in same region"];
    [self.locationManager startUpdatingLocation];
    [timerLocation invalidate];

}

- (IBAction)removePlist:(id)sender {

    [self removePlist];

}

- (void)removePlist {

    NSMutableArray *emptyArray = [[NSMutableArray alloc] init];
    NSLog(@"plist remove");
    [emptyArray writeToFile:filePath atomically:YES];

}

/** gesture method **/
- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {

    if (indexDay > 0) {

        indexDay--;
        CGRect frame = self.contentScrollView.frame;
        frame.origin.x = (self.view.bounds.size.width + margin ) * secondScale * indexDay;

        [self.contentScrollView scrollRectToVisible:frame animated:YES];
        [self.timeLineView animatedTimeLine:indexDay];
        [self animateDateLabel:transition];

    }
}

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer {

    if (indexDay < nbDay - 1) {

        indexDay++;
        CGRect frame = self.contentScrollView.frame;
        frame.origin.x = (self.view.bounds.size.width + margin) * secondScale * indexDay;
        [self.contentScrollView scrollRectToVisible:frame animated:YES];
        [self.timeLineView animatedTimeLine:indexDay];
        [self animateDateLabel:-transition];

    }

}

- (void)tapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {

    [self.view removeGestureRecognizer:leftGesture];
    [self.view removeGestureRecognizer:rightGesture];
    [self.view removeGestureRecognizer:closeGesture];
    [self.timeLineView setHidden:NO];
    [self animateTimeLine:upScale Alpha:0];

    [self animatedCloseScrollView];

}

- (void)swipeUp:(UISwipeGestureRecognizer *)recognizer {

    [self hideInformationData];
    [self animationCloseAllData];
    [self.view removeGestureRecognizer:upGesture];
    [self.view removeGestureRecognizer:self.informationDataGesture];
    [self.timeLineView setHidden:NO];

    [self animatedUpScrollView:0.5 First:NO];
    
}

- (void)informationData:(UITapGestureRecognizer *)tapGestureRecognizer {

    [self.view removeGestureRecognizer:self.informationDataGesture];

        int count = 0;

        for (UIView *view in self.contentScrollView.subviews) {

            for (UIView *subView in view.subviews) {

                if([subView isKindOfClass:[DataView class]]) {

                    DataView *dataView = (DataView *)subView;

                    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{

                        CGAffineTransform transform = dataView.transform;
                        dataView.transform = CGAffineTransformScale(transform, 1.2, 1.2);

                    } completion:nil];

                    [UIView animateWithDuration:0.5 delay:0.2 options:0 animations:^{

                        dataView.allDataView.transform = CGAffineTransformIdentity;
                        dataView.allDataView.alpha = 1;


                    } completion:^(BOOL finished){

                        [dataView.allDataView animatedAllLabel:dataView.allDataView.duration Translation:0 Alpha:1];
                        [self.view addGestureRecognizer:closeAllInformationDataGesture];

                    }];

                }
            }
            
            count++;
            
        }

}

- (void)closeAllInformationData:(UITapGestureRecognizer *)tapGestureRecognizer {

    [self animationCloseAllData];

}

- (void)closeInformationData:(UITapGestureRecognizer *)tapGestureRecognizer {

    [self hideInformationData];
    [self.view removeGestureRecognizer:self.closeInformationGesture];
    [self.view addGestureRecognizer:self.informationDataGesture];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return YES;
}

/** animation method **/
- (void)animateView:(float)scaleLayer ScaleView:(float)scaleView {

    int count = 0;
    float base = (self.view.bounds.size.width / 2) - (self.view.bounds.size.width * scaleLayer / 2);

    for (UIView *view in self.contentScrollView.subviews) {

        CGRect frame;
        frame.origin.x =  base + ((((self.view.bounds.size.width + margin) * scaleLayer)) * count);
        frame.origin.y = positionTop ;
        frame.size.height = heigtViewDetail * scaleLayer;
        frame.size.width = self.view.bounds.size.width * scaleLayer;
        view.frame = frame;

//        for (CAGradientLayer *gradientLayer in view.layer.sublayers) {
//
////            CGAffineTransform transform = self.timeLineView.transform;
//            gradientLayer.transform = CATransform3DMakeScale(scaleLayer, scaleLayer, 1);
//
//            for (CAShapeLayer *layer in gradientLayer.sublayers) {
//                [self animateLayer:layer Start:@1 End:[NSNumber numberWithFloat:scaleLayer] Delay:0];
//            }
//
//        }

//        for (UIView *subView in view.subviews) {
//
//            CGRect frame;
//            frame.origin.x = subView.frame.origin.x * scaleView;
//            frame.origin.y = subView.frame.origin.y * scaleView;
//            frame.size.height = subView.frame.size.height * scaleView;
//            frame.size.width = subView.frame.size.width * scaleView;
//            subView.frame = frame;
//
//        }

        for (UIView *subView in view.subviews) {

            CGRect frame;
            frame.origin.x = subView.frame.origin.x * scaleView;
            frame.origin.y = subView.frame.origin.y * scaleView;
            frame.size.height = subView.frame.size.height * scaleView;
            frame.size.width = subView.frame.size.width * scaleView;
            subView.frame = frame;

            if([subView isKindOfClass:[DataView class]]) {

                for (UIView *subSubView in subView.subviews) {
                    //                    subView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                    CGRect frame;
                    frame.origin.x = subSubView.frame.origin.x * scaleView;
                    frame.origin.y = subSubView.frame.origin.y * scaleView;
                    frame.size.height = subSubView.frame.size.height * scaleView;
                    frame.size.width = subSubView.frame.size.width * scaleView;
                    subSubView.frame = frame;
                    
                }
            }

        }

        count++;
    }

}

- (void)hideInformationData {

    int count = 0;

    for (UIView *view in self.contentScrollView.subviews) {

        for (UIView *subView in view.subviews) {

            if([subView isKindOfClass:[DataView class]]) {

                DataView *dataView = (DataView *)subView;
                dataView.informationViewActive = NO;

                [dataView.informationView animatedAllLabel:dataView.informationView.duration
                                               Translation:dataView.informationView.translation
                                                     Alpha:0];

                [UIView animateWithDuration:dataView.informationView.duration
                                      delay:dataView.informationView.duration
                                    options:0 animations:^{

                    [dataView scaleInformationView:dataView.informationView];


                } completion:nil];

                [UIView animateWithDuration:dataView.informationView.duration delay:0 options:0 animations:^{

                    [dataView.hoursLabel setAlpha:0];
                    
                } completion:nil];

                [dataView removeBorderButton];

            }

        }
        
        count++;
    }

}

- (void)animateLayer:(CAShapeLayer *)layer Start:(NSNumber *)start Ends:(NSNumber *)end Delay:(float)delay {

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation setFromValue:start]; //layer.transform = CATransform3DMakeScale(.65, .65, 1);
    [animation setToValue:end];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setDuration:0.5];
    [animation setBeginTime:CACurrentMediaTime() + delay];
    [animation setFillMode:kCAFillModeForwards];
    [animation setRemovedOnCompletion:NO];
    [layer addAnimation:animation forKey:@"scale"];

////    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
////
//////        self.timeLineView.alpha = alpha;
//////        CGAffineTransform transform = self.timeLineView.transform;
////        layer.transform = CATransform3DMakeScale([end floatValue], [end floatValue], 1);
//////        self.timeLineView.transform = CGAffineTransformScale(transform, scale, scale);
////
////    } completion:^(BOOL finished){}];
//
//    CGRect frame;
////    layer.frame.
//    frame.origin.x = layer.frame.origin.x * [end floatValue];
//    frame.origin.y = layer.frame.origin.y * [end floatValue];
//    frame.size.height = layer.frame.size.height * [end floatValue];
//    frame.size.width = layer.frame.size.width * [end floatValue];
//    layer.frame = frame;

}

- (void)animationCloseAllData {

    [self.view removeGestureRecognizer:closeAllInformationDataGesture];

    int count = 0;

    for (UIView *view in self.contentScrollView.subviews) {

        for (UIView *subView in view.subviews) {

            if([subView isKindOfClass:[DataView class]]) {

                DataView *dataView = (DataView *)subView;

                [dataView.allDataView animatedAllLabel:dataView.allDataView.duration
                                           Translation:dataView.allDataView.translation
                                                 Alpha:0];

                [UIView animateWithDuration:0.5 delay:dataView.allDataView.duration options:0 animations:^{

                    dataView.transform = CGAffineTransformIdentity;
                    [dataView scaleInformationView:dataView.allDataView];

                } completion:^(BOOL finished){

                    [self.view addGestureRecognizer:self.informationDataGesture];
                    
                }];

            }
        }
        
        count++;
        
    }

}

- (void)animateDateLabel:(float)translation {

    [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{

        [self.dateLabel setAlpha:0];
        [self.dateLabel setTransform:CGAffineTransformMakeTranslation(translation, 0)];
        [self.informationLabel setAlpha:0];
        [self.informationLabel setTransform:CGAffineTransformMakeTranslation(translation, 0)];

    } completion:^(BOOL finished){

        [self.dateLabel setText:[dateArray objectAtIndex:indexDay]];
        [self updateInformationLabel];
        [self.dateLabel setTransform:CGAffineTransformMakeTranslation(-translation, 0)];
        [self.informationLabel setTransform:CGAffineTransformMakeTranslation(-translation, 0)];

        [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{

            [self.dateLabel setTransform:CGAffineTransformMakeTranslation(0, 0)];
            [self.dateLabel setAlpha:1];
            [self.informationLabel setAlpha:1];
            [self.informationLabel setTransform:CGAffineTransformMakeTranslation(0, 0)];

        } completion:nil];

    }];



}

- (void)animateTimeLine:(float)scale Alpha:(float)alpha {

    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{

        self.timeLineView.alpha = alpha;
        CGAffineTransform transform = self.timeLineView.transform;
        self.timeLineView.transform = CGAffineTransformScale(transform, scale, scale);

    } completion:^(BOOL finished){}];

}

- (void)animatedUpScrollView:(float)duration First:(BOOL)boolean {

    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        [self animateView:firstScale ScaleView:firstScale];

        CGRect frame = self.contentScrollView.frame;
        frame.origin.x = (self.view.bounds.size.width + margin) * firstScale * indexDay;
        [self.contentScrollView scrollRectToVisible:frame animated:NO];

    } completion:^(BOOL finished){

        if (!boolean) {
             [self animateTimeLine:downScale Alpha:1];
        }

        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

//            [self animateView:secondScale ScaleView:(firstScale * secondScale)];
            int count = 0;
            float base = (self.view.bounds.size.width / 2) - (self.view.bounds.size.width * secondScale / 2);

            for (UIView *view in self.contentScrollView.subviews) {

                CGRect frame;
                frame.origin.x = base + ((((self.view.bounds.size.width + margin) * secondScale)) * count);
                frame.origin.y = self.view.bounds.size.height * 0.4 ;
                frame.size.height = heigtViewDetail * secondScale;
                frame.size.width = self.view.bounds.size.width * secondScale;
                view.frame = frame;

                //                for (CAShapeLayer *layer in view.layer.sublayers) {
                //
                //                    [self animateLayer:layer Start:[NSNumber numberWithFloat:firstScale] End:[NSNumber numberWithFloat:secondScale] Delay:0];
                //
                //                }

                //                for (UIView *subView in view.subviews) {
                //
                //                    CGRect frame;
                //                    frame.origin.x = subView.frame.origin.x / firstScale * secondScale;
                //                    frame.origin.y = subView.frame.origin.y / firstScale * secondScale;
                //                    frame.size.height = subView.frame.size.height / firstScale * secondScale;
                //                    frame.size.width = subView.frame.size.width / firstScale * secondScale;
                //                    subView.frame = frame;
                //
                //                }

                for (UIView *subView in view.subviews) {

                    CGRect frame;
                    frame.origin.x = subView.frame.origin.x / firstScale * secondScale;
                    frame.origin.y = subView.frame.origin.y / firstScale * secondScale;
                    frame.size.height = subView.frame.size.height / firstScale * secondScale;
                    frame.size.width = subView.frame.size.width / firstScale * secondScale;
                    subView.frame = frame;

                    if([subView isKindOfClass:[DataView class]]) {

                        for (UIView *subSubView in subView.subviews) {

                            CGRect frame;
                            frame.origin.x = subSubView.frame.origin.x / firstScale * secondScale;
                            frame.origin.y = subSubView.frame.origin.y / firstScale * secondScale;
                            frame.size.height = subSubView.frame.size.height / firstScale * secondScale;
                            frame.size.width = subSubView.frame.size.width / firstScale * secondScale;
                            subSubView.frame = frame;

                        }
                    }

                }

                count++;
            }
            
            CGRect frame = self.contentScrollView.frame;
            frame.origin.x = (self.view.bounds.size.width + margin) * secondScale * indexDay;
            [self.contentScrollView scrollRectToVisible:frame animated:NO];
            
        } completion:^(BOOL finished){

            if (!boolean) {

                [self.timeLineView setHidden:NO];
                [self.view addGestureRecognizer:leftGesture];
                [self.view addGestureRecognizer:rightGesture];
                [self.view addGestureRecognizer:closeGesture];

            }
            
        }];
        
    }];

}

- (void)animatedCloseScrollView {

    [UIView animateWithDuration:0.5  delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        int count = 0;

        for (UIView *view in self.contentScrollView.subviews) {

            CGRect frame;
            frame.origin.x = (self.view.bounds.size.width + margin) * count;
            frame.origin.y = positionTop;
            frame.size.height = heigtViewDetail;
            frame.size.width = self.view.bounds.size.width;
            view.frame = frame;
            //
            //            for (CAShapeLayer *layer in view.layer.sublayers) {
            //
            //                [self animateLayer:layer Start:[NSNumber numberWithFloat:secondScale] End:@1 Delay:0];
            //
            //            }

            for (UIView *subView in view.subviews) {

                CGRect frame;
                frame.origin.x = subView.frame.origin.x / secondScale;
                frame.origin.y = subView.frame.origin.y / secondScale;
                frame.size.height = subView.frame.size.height / secondScale;
                frame.size.width = subView.frame.size.width / secondScale;
                subView.frame = frame;

                if([subView isKindOfClass:[DataView class]]) {

                    for (UIView *subSubView in subView.subviews) {

                        CGRect frame;
                        frame.origin.x = subSubView.frame.origin.x / secondScale;
                        frame.origin.y = subSubView.frame.origin.y / secondScale;
                        frame.size.height = subSubView.frame.size.height / secondScale;
                        frame.size.width = subSubView.frame.size.width / secondScale;
                        subSubView.frame = frame;

                    }
                }

            }

            count++;

        }

        CGRect frame = self.contentScrollView.frame;
        frame.origin.x = (self.view.bounds.size.width + margin) * indexDay;
        [self.contentScrollView scrollRectToVisible:frame animated:NO];
        
    } completion:^(BOOL finished){
        
        [self.view addGestureRecognizer:upGesture];
        [self.view addGestureRecognizer:self.informationDataGesture];
        
    }];

}

- (void)animatedView:(UIView *)view Duration:(float)duration Delay:(float)delay Alpha:(float)alpha Translaton:(int)translation{

    [UIView animateWithDuration:duration delay:delay options:0 animations:^{

        [view setAlpha:alpha];
        [view setTransform:CGAffineTransformMakeTranslation(0, translation)];

    } completion:nil];
    
    
}

- (void)updateInformationLabel {

    float percent = (float) (indexDay + 1) / nbDay * 100;
    [self.informationLabel setText:[NSString stringWithFormat:@"Day %i / %i - %.f%%", (indexDay + 1), nbDay, percent ]];

}

/** upload method **/
- (IBAction)lauchSynchro:(id)sender {
    [self uploadFile];
}

- (void)uploadFile {
    [self sendLocalNotification:[NSString stringWithFormat:@"receive notification with %d", activeSyncho]];

    if (!activeSyncho) {

        activeSyncho = YES;
        self.app = [UIApplication sharedApplication];
        self.bgTask = [self.app beginBackgroundTaskWithExpirationHandler:^{
            [self.app endBackgroundTask:self.bgTask];
        }];
        NSLog(@"%lu", (unsigned long)self.bgTask);

        [self sendLocalNotification:@"upload files"];
        NSLog(@"upload files");
        if ([CMPedometer isStepCountingAvailable]) {
            [self updateDate];
            self.pedometer = [[CMPedometer alloc] init];
            [self queryPedometerDataFromDate:endDate toDate:startDate];
            //        [self updateData];
        } else {
            [self updateData];
        }

    }

}

- (void)updateData {

    NSLog(@"update");
    [self sendLocalNotification:@"Update data start"];
    NSMutableDictionary * dictio = [[NSMutableDictionary alloc]init];
    NSMutableArray *geoloArray = [[NSMutableArray alloc] init];
    if( [self contenPlist] != nil) {
        geoloArray = [self contenPlist];
    }
    [dictio setObject:geoloArray forKey:@"geoloc"];
    if (![CMPedometer isStepCountingAvailable]) {
        self.pedometerInformation = [[NSMutableDictionary alloc]init];
        [self.pedometerInformation setObject:[NSNumber numberWithInt:1] forKey:@"stepNumber"];
        [self.pedometerInformation setObject:[NSNumber numberWithFloat:1.f] forKey:@"distance"];
        [self.pedometerInformation setObject:[NSNumber numberWithFloat:1.f] forKey:@"vitesse"];
        [dictio setObject:self.pedometerInformation forKey:@"pedometer"];
    } else {
        [dictio setObject:self.pedometerInformation forKey:@"pedometer"];
    }

    [dictio setObject:[NSString stringWithFormat:@"%@", [[ApiController sharedInstance] getDateWithTime]] forKey:@"time"];
    [dictio setObject:[NSString stringWithFormat:@"%@", [[ApiController sharedInstance] getDate]] forKey:@"day"];

    NSString *urlString = [[ApiController sharedInstance] getUrlUploadData];
    NSDictionary *dict = [dictio mutableCopy];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer: [AFJSONRequestSerializer serializer]];
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        dictionary = responseObject[@"user"];
        [[ApiController sharedInstance] setUserLoad:dictionary];
        NSLog(@"end upload data");
        // for upload images
        [self getPhotoOnLibrary];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self sendLocalNotification:[NSString stringWithFormat:@"upload data failed"]];
        [self performSelector:@selector(updateData) withObject:nil afterDelay:120.0f];

    }];

}

- (void)getPhotoOnLibrary {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];

        NSMutableArray *inputPaths = [NSMutableArray new];
        NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *tmpDirURL = URLs[0];

        NSString *zippedPath = [NSString stringWithFormat:@"%@/%@.zip", [tmpDirURL path], [ApiController sharedInstance].user.token];

        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            if (alAsset) {
                if([((NSDate *)[alAsset valueForProperty:ALAssetPropertyDate]) compare: endDate] == NSOrderedDescending) {
                    // bug photo si que photo a update et rien apres
                    // Create image in tmp
                    ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                    UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                    NSData *data = UIImageJPEGRepresentation(latestPhoto, 0.2);
                    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",[tmpDirURL path], [representation filename]];
                    [data writeToFile:imagePath atomically:YES];
                    [inputPaths addObject:imagePath];

                } else {
                    // stop for getting photo
                    *innerStop = YES; *stop = YES;

                    if ([inputPaths count] != 0) {
                        NSLog(@"uploads photo");

                        [SSZipArchive createZipFileAtPath:zippedPath withFilesAtPaths:inputPaths];

                        NSString *urlString = [[ApiController sharedInstance] getUrlUploadImages];
                        NSString *fileName = [NSString stringWithFormat:@"%@.zip",[ApiController sharedInstance].user.token];

                        NSData *zipData = [[NSData alloc] initWithContentsOfFile:zippedPath];
                        NSURL *url=[NSURL URLWithString:urlString];
                        NSString *str = @"zip";

                        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
                        [request setHTTPShouldHandleCookies:NO];
                        [request setTimeoutInterval:30];
                        [request setURL:url];
                        [request setHTTPMethod:@"POST"];

                        NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831464368775746641449"];
                        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
                        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];

                        NSMutableData *body = [NSMutableData data];
                        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"currentEventID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[@"52344457901000006" dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", str, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[@"Content-Type: zip\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:zipData];
                        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        [request setHTTPBody:body];

                        NSError *error = [[NSError alloc] init];
                        NSHTTPURLResponse *response = nil;
                        NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

                        if ((long)[response statusCode] == 200) {
                            error = nil;
                            NSLog(@"photos are upload");
                            [self sendLocalNotification:@"photos are upload"];
                            dictionary = [NSJSONSerialization JSONObjectWithData:urlData
                                                                                     options:NSJSONReadingMutableContainers
                                                                                       error:&error];
                            [[ApiController sharedInstance] setUserLoad:dictionary[@"user"]];
                            [self updateCurrentDay];

                        } else {

                            NSLog(@"photos upload Fail !!");
                            [self sendLocalNotification:[NSString stringWithFormat:@"upload photo FAIL with code : %ld, error : %@ !!", (long)[response statusCode], error]];
                            [self performSelector:@selector(getPhotoOnLibrary) withObject:nil afterDelay:300.0f];

                        }

                        NSFileManager *fm = [NSFileManager defaultManager];
                        [fm removeItemAtPath:[tmpDirURL path] error:&error];
                        
                    } else {

                        NSLog(@"no photo to update");
                        [self sendLocalNotification:@"No photo to update"];
                        [self updateCurrentDay];

                    }
                }
            }
            
        }];
    } failureBlock: ^(NSError *error) {
        NSLog(@"No groups");
        [self updateCurrentDay];
    }];
}

- (void)updateCurrentDay {

    NSLog(@"update current day");
    DataView *dataView = [dataViewArray objectAtIndex:[dictionary[@"currentData"][@"day"] count] - 1];
    [self removePlist];
    Day *currentDay = [[Day alloc] initWithDictionary:dictionary[@"currentData"][@"day"][(int)dataView.tag]
                                                error:nil];
    [dataView generateDataAfterSynchro:currentDay];
    [self.app endBackgroundTask:self.bgTask];
    self.bgTask = UIBackgroundTaskInvalid;
    activeSyncho = NO;
    NSLog(@"%lu", (unsigned long)self.bgTask);

}

/** action button **/
- (IBAction)logoutAction:(id)sender {

    NSLog(@"logout");
    [[ApiController sharedInstance] removeUser];
    [self performSegueWithIdentifier:@"logout" sender:self];

}

@end