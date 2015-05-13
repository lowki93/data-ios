//
//  ViewController.m
//  Data
//
//  Created by kevin Budain on 03/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "ViewController.h"

#import "AFURLSessionManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface ViewController ()

@property (nonatomic) CLLocationCoordinate2D userLocation;

@end

BaseViewController *baseView;

float latitude, longitude, timeSynchro, distance, synchroTime;
int stepNumber;
NSDate *startDate, *endDate;
CGPoint centerCircle;
CGFloat radiusFirstCicle, radiusPhotoCicle, radiusGeolocCircle, radiusCaptaCircle, radiusPedometerCircle;
float heightContentView;

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    heightContentView = self.view.bounds.size.height * 0.75;

    /** update constraint **/
    [self.contentViewHeightConstraint setConstant:heightContentView];

    if([ApiController sharedInstance].experience != nil) {
        [self.startButton setHidden:YES];
        [self.synchronizeButton setHidden:NO];
        [self updateDateLabel];
        [self updateSynchroLabel];
        /** test draw circle **/
        [self createCircle];
        [self displayData];
    }

    // FOR GEOLOCALIZATION
    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled] ) {
        [self.locationManager  setDelegate: self];
        [self.locationManager  setDesiredAccuracy: kCLLocationAccuracyThreeKilometers];
        [self.locationManager  setDistanceFilter: 9999];
        if ([self.locationManager  respondsToSelector:@selector(requestAlwaysAuthorization)] ) {
            [self.locationManager  requestAlwaysAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        [self activeTracker];
////        [self.locationManager  startUpdatingLocation];
    }

    // FOR PODOMETER
    if ([CMPedometer isStepCountingAvailable]) {
        self.pedometer = [[CMPedometer alloc] init];
    }

    timeSynchro = 3;
    synchroTime = 10800.;
    [self updateDate];

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
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"error");
}

- (void)updateDate {
        NSDate *now = [[NSDate alloc] init];
        startDate = now;
        endDate = [startDate dateByAddingTimeInterval:-(1. * timeSynchro * 3600)];
}

- (NSString *)stringForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [formatter stringFromDate:date];
}

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

- (IBAction)buttonPressed:(id)sender {
    [self lauchSyncho];
}

- (IBAction)finishStart:(id)sender {
    NSLog(@"Finish start");

    NSString *urlString = [[ApiController sharedInstance] getUrlExperienceCreate];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dictionary = responseObject[@"user"];
        [[ApiController sharedInstance] setUserLoad:dictionary];
        [self.startButton setHidden:YES];
        [self.synchronizeButton setHidden:NO];
        [self createCircle];
        [self activeTracker];

        [self performSelector:@selector(lauchSyncho) withObject:nil afterDelay:3.f];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error code %d",[operation.response statusCode]);
        [self sendLocalNotification:@"server error"];
    }];
}

- (IBAction)logoutPressed:(id)sender {
    NSLog(@"logout and kill timer");
    [self.synchroTimer invalidate];
    [self.accuracyTimer invalidate];
    [self.locationTimer invalidate];
    [ApiController sharedInstance].user = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
    [self performSegueWithIdentifier:@"logout" sender:self];
}

- (void)sendLocalNotification:(NSString *)string {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    [localNotification setAlertBody:[NSString stringWithFormat:@"%@", string]];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

// get photo on library
- (void)getPhotoOnLibrary {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    // ALAssetsGroupLibrary , ALAssetsGroupSavedPhotos
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
                            [self sendLocalNotification:@"photos are upload"];
                            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData
                                                                                     options:NSJSONReadingMutableContainers
                                                                                       error:&error];
                            [[ApiController sharedInstance] setUserLoad:jsonData[@"user"]];
                            [self updateDataPhotoAfterSynchro];
                        } else {
                            [self sendLocalNotification:[NSString stringWithFormat:@"upload photo FAIL with code : %ld, error : %@ !!", (long)[response statusCode], error]];
                            [self performSelector:@selector(getPhotoOnLibrary) withObject:nil afterDelay:300.0f];
                        }

                        NSFileManager *fm = [NSFileManager defaultManager];
                        [fm removeItemAtPath:[tmpDirURL path] error:&error];
                    } else {
                        [self sendLocalNotification:@"No photo to update"];
                    }
                }
            }

        }];
    } failureBlock: ^(NSError *error) {
        NSLog(@"No groups");
    }];
}

- (void)updateSynchroLabel {
    NSInteger dayCount = [[ApiController sharedInstance].experience.day count] - 1;
    Day *currentDay = [ApiController sharedInstance].experience.day[dayCount];
    NSInteger dataCount = [currentDay.data count] - 1;
    Data *currentData = currentDay.data[dataCount];
    [self.synchroLabel setText:currentData.date];
//    [self synchroAuto];
}

- (void)drawCircle:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle strokeColor:(UIColor * )strokeColor fillColor:(UIColor * )fillColor dotted:(BOOL)dotted {

    CGFloat angle = ((M_PI * startAngle)/ 180);

    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:center
                                                         radius:radius
                                                     startAngle:angle
                                                       endAngle:2 * M_PI + angle
                                                      clockwise:YES];

    CAShapeLayer *progressLayer = [[CAShapeLayer alloc] init];
    [progressLayer setPath:aPath.CGPath];
    [progressLayer setStrokeColor:strokeColor.CGColor];
    [progressLayer setFillColor:fillColor.CGColor];
    [progressLayer setLineWidth:1.f];
    [progressLayer setStrokeStart:0/100];
    [progressLayer setStrokeEnd:100/100];
    if(dotted) {
        [progressLayer setLineJoin:kCALineJoinRound];
        [progressLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],nil]];
    }
    [self.contentView.layer addSublayer:progressLayer];

//
//    [CATransaction begin];
//    CABasicAnimation *animateStrokeDown = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    [animateStrokeDown setFromValue:[NSNumber numberWithFloat:0/100.]];
//    [animateStrokeDown setToValue:[NSNumber numberWithFloat:100/100.]];
//    [animateStrokeDown setDuration:2];
//    [animateStrokeDown setFillMode:kCAFillModeForwards];
//    [animateStrokeDown setRemovedOnCompletion:NO];
//    [progressLayer addAnimation:animateStrokeDown forKey:@"strokeEnd"];
//    [CATransaction commit];
}

- (void)createCircle {
    centerCircle = CGPointMake(self.view.bounds.size.width/2, heightContentView/2);
    radiusFirstCicle = (self.view.bounds.size.width * 0.046875) / 2;
    radiusPhotoCicle = (self.view.bounds.size.width * 0.203125) / 2;
    radiusGeolocCircle = (self.view.bounds.size.width * 0.484375) / 2;
    radiusCaptaCircle = (self.view.bounds.size.width * 0.6484375) / 2;
    radiusPedometerCircle = (self.view.bounds.size.width * 0.8125) / 2;

    [self drawCircle:centerCircle radius:radiusFirstCicle startAngle:0 strokeColor:baseView.lightBlue fillColor:[UIColor clearColor] dotted:NO];
    [self drawCircle:centerCircle radius:radiusPhotoCicle startAngle:20 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:YES];
    [self drawCircle:centerCircle radius:radiusGeolocCircle startAngle:40 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:NO];
    [self drawCircle:centerCircle radius:radiusCaptaCircle startAngle:60 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:NO];
    [self drawCircle:centerCircle radius:radiusPedometerCircle startAngle:80 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:YES];
}

- (void)displayData {
    if([ApiController sharedInstance].experience.day != nil ) {
        NSInteger dayCount = [[ApiController sharedInstance].experience.day count] - 1;
        Day *currentDay = [ApiController sharedInstance].experience.day[dayCount];
        for (int i = 0; i < [currentDay.data count]; i++) {
            int nbSynchro = i;
            Data *currentData = currentDay.data[i];
            /** for photos **/
            [self updatePhotoData:currentData Synchro:nbSynchro];
            /** for geoloc **/
            [self updateGeolocData:currentData Synchro:nbSynchro];
        }
    }
}

- (void)updateDataGeolocAfterSynchro {
    NSLog(@"update data geoloc");
    Data *currentData = [[ApiController sharedInstance] GetLastData];
    int nbSynchro = [[ApiController sharedInstance]getIndexData];
    /** for geoloc **/
    [self updateGeolocData:currentData Synchro:nbSynchro];
}

- (void)updateDataPhotoAfterSynchro {
    NSLog(@"update data photo");
    Data *currentData = [[ApiController sharedInstance] GetLastData];
    int nbSynchro = [[ApiController sharedInstance]getIndexData];
    /** for phoho **/
    [self updatePhotoData:currentData Synchro:nbSynchro];
}

- (void)updatePhotoData:(Data *)data Synchro:(NSInteger)nbSynchro {
    for (int i = 0; i < [data.photos count]; i++) {
        [self drawCirclePhoto:nbSynchro];
    }
}

- (void)drawCirclePhoto:(NSInteger)nbSynchro {
    int lowerAlpha = 1;
    int upperAlpha = 7;
    float randomAlpha = (lowerAlpha + arc4random() % (upperAlpha - lowerAlpha)) / 10. ;
    int randomAngle = arc4random() % 45;
    CGFloat theta = ((M_PI * randomAngle)/ 180) - M_PI_2 + (M_PI_4 * nbSynchro );
    CGPoint newCenter = CGPointMake(self.view.bounds.size.width/2 + cosf(theta) * radiusPhotoCicle, sinf(theta) * radiusPhotoCicle + heightContentView/2);
    [self drawCircle:newCenter radius:10 startAngle:0 strokeColor:[UIColor clearColor] fillColor:[baseView.circlePhotoColor colorWithAlphaComponent:randomAlpha] dotted:NO];
}

- (void)updateGeolocData:(Data *)data Synchro:(NSInteger)nbSynchro {
    for (int i = 0; i < [data.atmosphere count]; i++) {
        [self drawCircleGeoloc:nbSynchro];
    }
}

- (void)drawCircleGeoloc:(NSInteger)nbSynchro {
    /* random alpha */
    int lowerAlpha = 1;
    int upperAlpha = 7;
    float randomAlpha = (lowerAlpha + arc4random() % (upperAlpha - lowerAlpha)) / 10. ;
    /* random angle */
    int randomAngle = arc4random() % 45;
    /* random radius */
    int lowerRadius = radiusGeolocCircle - 20;
    int upperRadius = radiusGeolocCircle + 20;
    int randomRadius = lowerRadius + arc4random() % (upperRadius - lowerRadius);
    /* random radius */
    int lowerCircleRadius = 5;
    int upperCircleRadius = 20;
    int randomCircleRadius = lowerCircleRadius + arc4random() % (upperCircleRadius - lowerCircleRadius);
    CGFloat theta = ((M_PI * randomAngle)/ 180) - M_PI_2 + (M_PI_4 * nbSynchro );
    CGPoint newCenter = CGPointMake(self.view.bounds.size.width/2 + cosf(theta) * randomRadius, sinf(theta) * randomRadius + heightContentView/2);
    [self drawCircle:newCenter radius:randomCircleRadius startAngle:0 strokeColor:[UIColor clearColor] fillColor:[baseView.circlegeolocColor colorWithAlphaComponent:randomAlpha] dotted:NO];

}

- (void)lauchSyncho {
    if ([CMPedometer isStepCountingAvailable]) {
        [self updateDate];
        [self queryPedometerDataFromDate:endDate toDate:startDate];
    } else {
        [self updateData];
    }
}

- (void)updateData {

    if ([[ApiController sharedInstance].location count] != 0){
        NSLog(@"update");
        [self sendLocalNotification:@"Update data start"];
        NSMutableDictionary * dictio = [[NSMutableDictionary alloc]init];
        [dictio setObject:[ApiController sharedInstance].location forKey:@"geoloc"];
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

            NSDictionary *dictionary = responseObject[@"user"];
            if( (unsigned long)[dictionary[@"currentData"][@"day"] count] != [ApiController sharedInstance].nbDay) {
                self.contentView.layer.sublayers = nil;
                [self createCircle];
            }
            [self updateDateLabel];
            [[ApiController sharedInstance] setUserLoad:dictionary];
            [self sendLocalNotification:@"data are upload"];
            [[ApiController sharedInstance].location removeAllObjects];
            [self updateDataGeolocAfterSynchro];
            NSLog(@"end upload data");
            [self updateSynchroLabel];
            [self.synchroTimer invalidate];
            [self.accuracyTimer invalidate];
            [self.locationTimer invalidate];
            [self activeTracker];
            // for upload images
            [self getPhotoOnLibrary];


        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            NSLog(@"%@", error);
            NSLog(@"error code %ld",(long)[operation.response statusCode]);
            [self sendLocalNotification:[NSString stringWithFormat:@"upload data FAIL with code : %ld, error : %@ !!", (long)[operation.response statusCode], error]];
//            [self performSelector:@selector(updateData) withObject:nil afterDelay:120.0f];

        }];
    }

}


//- (void)synchroAuto {
//    NSLog(@"active synchro");
//    // 3600 -> 1h, 1200 -> 20mn, 10800 -> 3h
//    self.synchroTimer = [NSTimer scheduledTimerWithTimeInterval:10800.
//                                                         target:self
//                                                       selector:@selector(lauchSyncho)
//                                                       userInfo:nil repeats:NO];
//}

- (void)activeTracker {
    NSLog(@"active location tracker");
    [self sendLocalNotification:@"start location tracker"];
    UIAlertView * alert;

    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){

        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];

    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){

        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];

    } else{

        // Override point for customization after application launch.
//        self.locationManager = [[CLLocationManager alloc] init];
//        self.locationManager.delegate = self;
        self.geocoder = [[CLGeocoder alloc] init];
//        [self.locationManager startUpdatingLocation];

        [self performSelector:@selector(updateLocation) withObject:nil afterDelay:1.f];

        self.accuracyTimer = [NSTimer scheduledTimerWithTimeInterval:300.
                                                              target:self
                                                            selector:@selector(changeAccuracy)
                                                            userInfo:nil
                                                             repeats:YES];

//        self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:10.
//                                                              target:self
//                                                            selector:@selector(updateLocation)
//                                                            userInfo:nil
//                                                             repeats:YES];
    }

}

- (void) changeAccuracy {

    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];

}

/** get current Location **/
- (void)locationManager:(CLLocationManager *)lm didUpdateLocations:(NSArray *)locations{

    self.location = [locations lastObject];
    latitude = self.location.coordinate.latitude;
    longitude = self.location.coordinate.longitude;
    [lm setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    [lm setDistanceFilter:99999];

    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:[self.location coordinate] radius:300 identifier:[[NSUUID UUID] UUIDString]];

//    NSLog(@"%i",[self.locationManager requestStateForRegion:region]);

    // Start Monitoring Region
    [self.locationManager startMonitoringForRegion:region];
    [self.locationManager stopUpdatingLocation];

}

/** update location Array **/
- (void)updateLocation {
    NSMutableDictionary *myBestLocation = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *addressLocation = [[NSMutableDictionary alloc] init];

    /** add location and distance **/
    [myBestLocation setObject:[NSNumber numberWithFloat:self.location.coordinate.latitude] forKey:@"latitude"];
    [myBestLocation setObject:[NSNumber numberWithFloat:self.location.coordinate.longitude] forKey:@"longitude"];
    [myBestLocation setObject:[NSNumber numberWithFloat:[self.lastLocation distanceFromLocation:self.location]] forKey:@"distance"];

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
    }];
}

- (void)updateDateLabel {
    [self.dataLabel setText:[[ApiController sharedInstance] getDate]];
}

- (void)saveLocation:(NSMutableDictionary *)myBestLocation {

    [myBestLocation setObject:[NSString stringWithFormat:@"%@", [[ApiController sharedInstance] getDateWithTime]] forKey:@"time"];
    self.lastLocation = self.location;
    [[ApiController sharedInstance].location addObject:myBestLocation];

    [self sendLocalNotification:[NSString stringWithFormat:@"nb location : %lu - location : %f, %f", (unsigned long)[[ApiController sharedInstance].location count],self.location.coordinate.latitude, self.location.coordinate.longitude]];
    if ([[ApiController sharedInstance].location count] >= 15) {
        [self lauchSyncho];
    }

}

//-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
//    NSLog(@"Welcome to %@", region.identifier);
//    NSLog(@"location : %f, %f", self.location.coordinate.latitude, self.location.coordinate.longitude);
//    [self sendLocalNotification:@"new region"];
//}
//
//
//-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
//    NSLog(@"Bye bye");
//    [self.locationManager startUpdatingLocation];
//}
//
//-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
//    NSLog(@"Now monitoring for %@", region.identifier);
//    [self sendLocalNotification:@"start monitoring region"];
//}
//
//-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
//    NSLog(@"alor");
//    [self sendLocalNotification:@"didDetermineState"];
//}

@end