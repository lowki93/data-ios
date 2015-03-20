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

                    NSString *urlString = @"http://data.vm:5000/api/files/uploads?access_token=c006d1dbee4d6d2077611fdbd8064b52";
                    
                    NSData *zipData = [[NSData alloc] initWithContentsOfFile:zippedPath]; // zipFile contains the zip file path
                    
                    NSString *str = @"image";
                    
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
                    [request setHTTPShouldHandleCookies:NO];
                    [request setTimeoutInterval:30];
                    [request setURL:[NSURL URLWithString:urlString]];
                    
                    [request setHTTPMethod:@"POST"];
                    
                    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831464368775746641449"];
                    
                    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
                    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
                    
                    NSMutableData *body = [NSMutableData data];
                    
                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"currentEventID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"52344457901000006" dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    if (zipData) {
                        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"myimage.zip\"\r\n", str] dataUsingEncoding:NSUTF8StringEncoding]];
                        
                        [body appendData:[@"Content-Type: zip\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:zipData];
                        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    
                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [request setHTTPBody:body];
                    
                    
                    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    NSLog(@"Response : %@",returnString);
                    
                    NSFileManager *fm = [NSFileManager defaultManager];
                    NSError *error = nil;
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
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    [localNotification setAlertBody:@"sa marche"];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end