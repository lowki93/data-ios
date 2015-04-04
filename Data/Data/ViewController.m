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

float latitude, longitude, distance;
int stepNumber;
NSDate *startDate, *endDate;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if([ApiController sharedInstance].experience != nil) {
        [self.startButton setHidden:YES];
        [self.synchronizeButton setHidden:NO];
    }

    // FOR GEOLOCALIZATION
    locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled] ) {
        [locationManager setDelegate: self];
        [locationManager setDesiredAccuracy: kCLLocationAccuracyBest];
        [locationManager setDistanceFilter: 100.f];
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] ) {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    }
    
    // FOR PODOMETER
    if ([CMPedometer isStepCountingAvailable]) {
        self.pedometer = [[CMPedometer alloc] init];
    }

    startDate = [[ApiController sharedInstance] getCurrentDate];
    float time = 3;
    endDate = [startDate dateByAddingTimeInterval:-(1. * time * 3600)];

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
    
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"error");
}

- (NSString *)stringForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [formatter stringFromDate:date];
}

- (void)getPedometerInformation:(NSDate *)startDate toDate:(NSDate *)endDate {
    
    [self.pedometer queryPedometerDataFromDate:startDate
                                        toDate:endDate
                                   withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (error) {
//                                               NSLog(@"error");
                                           } else {
                                               stepNumber = [pedometerData.numberOfSteps intValue];
                                               distance = [pedometerData.distance floatValue];
                                           }
                                       });
                                   }];
}

- (IBAction)buttonPressed:(id)sender {
//    [self getPedometerInformation:endDate toDate:startDate];

    NSString *urlString = [[ApiController sharedInstance] getUrlUploadData];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"latitude":[NSString stringWithFormat:@"%f", latitude],
                                 @"longitude":[NSString stringWithFormat:@"%f", longitude],
                                 @"time": [NSString stringWithFormat:@"%f", [[[ApiController sharedInstance] getCurrentDate] timeIntervalSince1970]]
                                };
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dictionary = responseObject[@"user"];
        [[ApiController sharedInstance] setUserLoad:dictionary];
        [self sendLocalNotification:@"information are upload"];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        long responseCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        if(responseCode == 200) {
            [self sendLocalNotification:@"information are upload"];
        } else {
            [self sendLocalNotification:@"server error"];
        }
    }];

    // for upload images
//    [self getPhotoOnLibrary];
}

- (IBAction)finishStart:(id)sender {
    
     NSString *urlString = [[ApiController sharedInstance] getUrlExperienceCreate];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dictionary = responseObject[@"user"];
        [[ApiController sharedInstance] setUserLoad:dictionary];
        [self.startButton setHidden:YES];
        [self.synchronizeButton setHidden:NO];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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

// get photo on library
- (void)getPhotoOnLibrary {
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

                    NSString *urlString = [[ApiController sharedInstance] getUrlUploadImages];
                    NSString *fileName = [NSString stringWithFormat:@"%@.zip",[ApiController sharedInstance].user.token];

                    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                                    multipartFormRequestWithMethod:@"POST"
                                                    URLString:urlString
                                                    parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                        [formData appendPartWithFileURL:[NSURL fileURLWithPath:zippedPath]
                                                                                   name:@"zip"
                                                                               fileName:fileName
                                                                               mimeType:@"image/jpeg"
                                                                                  error:nil];
                                                    }
                                                    error:nil];

                    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                    NSProgress *progress = nil;

                    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                        if (error) {
                           [self sendLocalNotification:@"photos are upload FAIL !!"];
                        } else {
                            [self sendLocalNotification:@"photos are upload"];
                        }
                    }];
                                 
                    [uploadTask resume];

                    NSError *error = [[NSError alloc] init];
                    NSFileManager *fm = [NSFileManager defaultManager];
                    [fm removeItemAtPath:[tmpDirURL path] error:&error];
                    
                }
            }
        }];
    } failureBlock: ^(NSError *error) {
        NSLog(@"No groups");
    }];
}

@end