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
    NSDate *startDate = [NSDate date];
    float time = 3;
    NSDate *endDate = [startDate dateByAddingTimeInterval:-(1. * time * 3600)];
    [self queryDataFrom:endDate toDate:startDate];

    // get photo on library
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
        NSString *zippedPath = [NSString stringWithFormat:@"%@/toto.zip", [tmpDirURL path]];
        NSMutableArray *inputPaths = [NSMutableArray new];

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
                    *stop = YES; *innerStop = YES;
                    [SSZipArchive createZipFileAtPath:zippedPath withFilesAtPaths:inputPaths];
                    
                    NSData *zipData = [[NSData alloc] initWithContentsOfFile:zippedPath]; // zipFile contains the zip file path
                    
                    NSMutableURLRequest *request = [[ApiController sharedInstance] uploadZip:zipData ];
                    
                    NSError *error = [[NSError alloc] init];
                    NSHTTPURLResponse *response = nil;
                    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                    if ((long)[response statusCode] == 201) {
                        error = nil;
                        [self sendLocalNotification:@"photos are upload"];
                    } else if((long)[response statusCode] == 409 || (long)[response statusCode] == 404) {
                        error = nil;
                        NSDictionary *jsonData = [[ApiController sharedInstance] serializeJson:urlData Error:error];
                        [self sendLocalNotification:jsonData[@"error"]];
                    } else {
                        [self sendLocalNotification:@"photos are upload FAIL !!"];
                    }
                    
                    NSFileManager *fm = [NSFileManager defaultManager];
                    [fm removeItemAtPath:[tmpDirURL path] error:&error];

                }
            }
        }];
    } failureBlock: ^(NSError *error) {
        NSLog(@"No groups");
    }];

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
    
//    http://api.openweathermap.org/data/2.5/weather?lat=48.83&lon=2.35
    
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
    [self sendLocalNotification:@"sa marche"];
}

- (IBAction)logoutPressed:(id)sender {
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

@end