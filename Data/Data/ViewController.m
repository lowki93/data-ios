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

float latitude, longitude, distance;
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

    /** test draw circle **/
    centerCircle = CGPointMake(self.view.bounds.size.width/2, heightContentView/2);
    radiusFirstCicle = (self.view.bounds.size.width * 0.046875) / 2;
    radiusPhotoCicle = (self.view.bounds.size.width * 0.203125) / 2;
    radiusGeolocCircle = (self.view.bounds.size.width * 0.484375) / 2;
    radiusCaptaCircle = (self.view.bounds.size.width * 0.6484375) / 2;
    radiusPedometerCircle = (self.view.bounds.size.width * 0.8125) / 2;

    [self drawCircle:centerCircle radius:radiusFirstCicle startAngle:0 strokeColor:baseView.lightBlue fillColor:[UIColor clearColor] dotted:NO];
    [self drawCircle:centerCircle radius:radiusPhotoCicle startAngle:20 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:YES];
    [self drawCircle:centerCircle radius:radiusGeolocCircle startAngle:40 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:NO];
//    [self drawCircle:centerCircle radius:radiusCaptaCircle startAngle:60 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:NO];
    [self drawCircle:centerCircle radius:radiusPedometerCircle startAngle:80 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:YES];

    int nbSynchro = 3;

    for (int i = 0; i < 3; i++) {
        int lowerAlpha = 1;
        int upperAlpha = 7;
        float randomAlpha = (lowerAlpha + arc4random() % (upperAlpha - lowerAlpha)) / 10. ;
        int randomAngle = arc4random() % 45;
        CGFloat theta = ((M_PI * randomAngle)/ 180) - M_PI_2 + (M_PI_4 * nbSynchro );
        CGPoint newCenter = CGPointMake(self.view.bounds.size.width/2 + cosf(theta) * radiusPhotoCicle, sinf(theta) * radiusPhotoCicle + heightContentView/2);
        [self drawCircle:newCenter radius:10 startAngle:0 strokeColor:[UIColor clearColor] fillColor:[baseView.circlePhotoColor colorWithAlphaComponent:randomAlpha] dotted:NO];
    }

    for (int i = 0; i < 5; i++) {
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


    if([ApiController sharedInstance].experience != nil) {
        [self.startButton setHidden:YES];
        [self.synchronizeButton setHidden:NO];
        [self updateSynchroLabel];
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
        [self updateSynchroLabel];

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
        [self sendLocalNotification:@"server error"];
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

- (void)updateSynchroLabel {
    NSInteger dayCount = [[ApiController sharedInstance].experience.day count] - 1;
    Day *currentDay = [ApiController sharedInstance].experience.day[dayCount];
    NSInteger dataCount = [currentDay.data count] - 1;
    Data *currentData = currentDay.data[dataCount];
    [self.synchroLabel setText:currentData.date];
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
    [progressLayer setStrokeEnd:0/100];
    [self.contentView.layer addSublayer:progressLayer];

    if(dotted) {
        [progressLayer setLineJoin:kCALineJoinRound];
        [progressLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],nil]];
    }

    [CATransaction begin];
    CABasicAnimation *animateStrokeDown = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [animateStrokeDown setFromValue:[NSNumber numberWithFloat:0/100.]];
    [animateStrokeDown setToValue:[NSNumber numberWithFloat:100/100.]];
    [animateStrokeDown setDuration:2];
    [animateStrokeDown setFillMode:kCAFillModeForwards];
    [animateStrokeDown setRemovedOnCompletion:NO];
    [progressLayer addAnimation:animateStrokeDown forKey:@"strokeEnd"];
    [CATransaction commit];
}

@end