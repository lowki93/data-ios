//
//  GeolocViewController.m
//  Data
//
//  Created by kevin Budain on 30/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "GeolocViewController.h"
#import "BaseViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface GeolocViewController ()

@end

BaseViewController *baseView;
NSArray *titleArray, *explainArray;
NSMutableDictionary *pedometerInformation;
NSDictionary *dictionary;
NSString *idString, *tokenString;

int step, nbStep, translation, translationLoader;
float duration;
bool firstGeoloc, pedometerIsActive;

@implementation GeolocViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"];
    [[ApiController sharedInstance] setUserLoad:dictionary];

    translationLoader =  20;
    [self hideingSynchro];

    pedometerIsActive = false,
    step = 1;
    duration = 0.5f;
    translation = 75;
    firstGeoloc = true;

    if ([CMPedometer isStepCountingAvailable]) {

        pedometerIsActive = true;
        titleArray = [@[@"COEUR", @"PEDOMETER", @"GEOLOCATION", @"PHOTOS", @""] mutableCopy ];
        explainArray = [@[@"voici le coeur de ton experience\nelle évolura en fonction\nde tes données captée ", @"explain pedometer", @"geoloc ", @"explain photos ", @""] mutableCopy ];
        nbStep = 4;

    } else {

        titleArray = [@[@"COEUR", @"GEOLOCATION", @"PHOTOS", @""] mutableCopy ];
         explainArray = [@[@"voici le coeur de ton experience\nelle évolura en fonction\nde tes données captée ", @"explain geoloc",@"explain photos ", @""] mutableCopy ];
        nbStep = 3;

    }

    idString = [NSString stringWithFormat:@"%@", [ApiController sharedInstance].user._id];
    tokenString = [NSString stringWithFormat:@"%@", [ApiController sharedInstance].user.token];
    [self.loaderImageView initImageView];

    [baseView addLineHeight:1.4 Label:self.synchroniseLabel];

    NSString *informationParingString2 = [self.learnLabel text];
    [self.learnLabel setText:[informationParingString2 uppercaseString]];

    [baseView addLineHeight:1.4 Label:self.learnLabel];

    [self animatedView:self.captaTitleLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.learnLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.lineView Duration:0 Delay:0 Alpha:0 Translaton:0];
    [self animatedView:self.titleView Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.nextButton Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.explainLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self changeTextLabel];
    [self.nextButton initButton];

    [self performSelector:@selector(firstAnimation) withObject:nil afterDelay:duration];
}

- (void)firstAnimation {

    [self animatedView:self.captaTitleLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.titleView Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.nextButton Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.explainLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.learnLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.lineView Duration:duration Delay:0 Alpha:1 Translaton:0];

    NSDictionary *sokectDictionary = @{
                                       @"activation": @"heart",
                                       @"data": @true
                                       };
    [self performSelector:@selector(sendDataWithSocket:) withObject:sokectDictionary afterDelay:duration];
//    [self sendDataWithSocket:sokectDictionary];

}

- (void)startLocation {

    self.locationManager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];

    if ([CLLocationManager locationServicesEnabled] ) {

        [self.locationManager  setDelegate: self];
        [self.locationManager  setDesiredAccuracy: kCLLocationAccuracyThreeKilometers];
        [self.locationManager  setDistanceFilter: 9999];

        if ([self.locationManager  respondsToSelector:@selector(requestAlwaysAuthorization)] ) {

            [self.locationManager performSelector:@selector(requestAlwaysAuthorization) withObject:nil afterDelay:duration * 2];

        }
        [self.locationManager startUpdatingLocation];
    }


}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    [self.locationManager stopUpdatingLocation];
    if(firstGeoloc){
        firstGeoloc = false;
    NSLog(@"get location");
    [self displayingSynchro];
    CLLocation *location = [locations lastObject];

    NSMutableDictionary *myBestLocation = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *addressLocation = [[NSMutableDictionary alloc] init];

    /** add location and distance **/
    [myBestLocation setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"latitude"];
    [myBestLocation setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"longitude"];
    [myBestLocation setObject:[NSNumber numberWithFloat:0.] forKey:@"distance"];

    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks lastObject];
            /** address location **/
            [addressLocation setObject:[NSString stringWithFormat:@"%@", placemark.subThoroughfare] forKey:@"numbers"];
            [addressLocation setObject:[NSString stringWithFormat:@"%@", placemark.thoroughfare] forKey:@"way"];
            [addressLocation setObject:[NSString stringWithFormat:@"%@", placemark.postalCode] forKey:@"postalCode"];
            [addressLocation setObject:[NSString stringWithFormat:@"%@", placemark.locality] forKey:@"town"];
            [addressLocation setObject:[NSString stringWithFormat:@"%@", placemark.administrativeArea] forKey:@"area"];
            [addressLocation setObject:[NSString stringWithFormat:@"%@", placemark.country] forKey:@"country"];
            /** add to myBestLocation **/
            [myBestLocation setObject:addressLocation forKey:@"address"];
            [self sendLocation:myBestLocation];

        } else {

            [myBestLocation setObject:addressLocation forKey:@"address"];
            [self sendLocation:myBestLocation];

        }
    }];

    }
}

- (void)sendLocation:(NSMutableDictionary *)myBestLocation {

    [myBestLocation setObject:[NSString stringWithFormat:@"%@", [[ApiController sharedInstance] getDateWithTime]] forKey:@"time"];

    [self uploadFirstGeoloc:myBestLocation];

}

- (void)uploadFirstGeoloc:(NSMutableDictionary *)geolocDictionary {

    NSMutableDictionary * dictio = [[NSMutableDictionary alloc]init];
    [dictio setObject:geolocDictionary forKey:@"geoloc"];

    pedometerInformation = [[NSMutableDictionary alloc]init];
    [pedometerInformation setObject:[NSNumber numberWithInt:1] forKey:@"stepNumber"];
    [pedometerInformation setObject:[NSNumber numberWithFloat:1.f] forKey:@"distance"];
    [pedometerInformation setObject:[NSNumber numberWithFloat:1.f] forKey:@"vitesse"];
    [dictio setObject:pedometerInformation forKey:@"pedometer"];

    [dictio setObject:[NSString stringWithFormat:@"%@", [[ApiController sharedInstance] getDateWithTime]] forKey:@"time"];
    [dictio setObject:[NSString stringWithFormat:@"%@", [[ApiController sharedInstance] getDate]] forKey:@"day"];

    NSString *urlString = [[ApiController sharedInstance] getUrlParringGeoloc:idString Token:tokenString];
    NSDictionary *dict = [dictio mutableCopy];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer: [AFJSONRequestSerializer serializer]];
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        dictionary = responseObject[@"user"];
        [[ApiController sharedInstance] setUserLoad:dictionary];
        NSDictionary *sokectDictionary = @{
                                           @"activation": @"geolocation",
                                           @"token": [ApiController sharedInstance].user.token,
                                           @"data": dictionary[@"currentData"][@"day"][0][@"data"][0][@"atmosphere"]
                                           };
        NSLog(@"first geoloc done");
        [self performSelector:@selector(sendDataWithSocket:) withObject:sokectDictionary afterDelay:2];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self performSelector:@selector(uploadFirstGeoloc:) withObject:[NSArray arrayWithObjects:geolocDictionary, nil] afterDelay:5.0f];

    }];

}

- (void)queryPedometerDataFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    [self displayingSynchro];
    [self.pedometer queryPedometerDataFromDate:startDate
                                        toDate:endDate
                                   withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (error) {
                                               NSLog(@"%@", error);
                                           } else {
                                               pedometerInformation = [[NSMutableDictionary alloc]init];
                                               float distance = [pedometerData.distance floatValue];
                                               [pedometerInformation setObject:[NSNumber numberWithInt:[pedometerData.numberOfSteps intValue]] forKey:@"stepNumber"];
                                               [pedometerInformation setObject:[NSNumber numberWithFloat:distance] forKey:@"distance"];
                                               [pedometerInformation setObject:[NSNumber numberWithFloat:(distance / 1000 / 1)] forKey:@"vitesse"];

                                               [self performSelector:@selector(uploadPodometer) withObject:nil afterDelay:5];

                                           }
                                       });
                                   }];
}

- (void)uploadPodometer {

    NSMutableDictionary * dictio = [[NSMutableDictionary alloc]init];
    [dictio setObject:pedometerInformation forKey:@"pedometer"];

    NSString *urlString = [[ApiController sharedInstance] getUrlUploadPodometer];
    NSDictionary *dict = [dictio mutableCopy];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer: [AFJSONRequestSerializer serializer]];
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        dictionary = responseObject[@"user"];
        [[ApiController sharedInstance] setUserLoad:dictionary];
        [[ApiController sharedInstance] setUserLoad:dictionary];
        NSDictionary *sokectDictionary = @{
                                           @"activation": @"pedometer",
                                           @"token": [ApiController sharedInstance].user.token,
                                           @"data": pedometerInformation
                                           };
         [self performSelector:@selector(sendDataWithSocket:) withObject:sokectDictionary afterDelay:2];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self performSelector:@selector(uploadPodometer) withObject:nil afterDelay:5.0f];

    }];

}

- (void)getPhotos {
    NSLog(@"get photos");

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

                // bug photo si que photo a update et rien apres
                // Create image in tmp
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                NSData *data = UIImageJPEGRepresentation(latestPhoto, 0.2);
                NSString *imagePath = [NSString stringWithFormat:@"%@/%@",[tmpDirURL path], [representation filename]];
                [data writeToFile:imagePath atomically:YES];
                [inputPaths addObject:imagePath];

                // stop for getting photo
                *innerStop = YES; *stop = YES;

                if ([inputPaths count] != 0) {

                    NSLog(@"parring upload photos");
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
                        dictionary = [NSJSONSerialization JSONObjectWithData:urlData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
                        [[ApiController sharedInstance] setUserLoad:dictionary[@"user"]];
                        NSDictionary *sokectDictionary = @{
                                                           @"activation": @"photos",
                                                           @"token": [ApiController sharedInstance].user.token,
                                                           @"data": dictionary[@"user"][@"currentData"][@"day"][0][@"data"][0][@"photos"]
                                                           };

                        [self performSelector:@selector(sendDataWithSocket:) withObject:sokectDictionary afterDelay:2];

                    } else {

                        NSLog(@"error upload photos : %@", error);
                        [self performSelector:@selector(getPhotos) withObject:nil afterDelay:5.];

                    }
                    
                    NSFileManager *fm = [NSFileManager defaultManager];
                    [fm removeItemAtPath:[tmpDirURL path] error:&error];
                    
                }
            }
            
        }];
        
    } failureBlock: ^(NSError *error) {
        
        NSLog(@"no photos for parring");
        [self selectDay];
        
    }];
    
}

- (void)updateStepLabel {

    [self hideSynchroLabel];
    [self performSelector:@selector(changeTextLabel) withObject:nil afterDelay:duration];
//    [self showSynchroLabel];
    [self performSelector:@selector(showSynchroLabel) withObject:nil afterDelay:duration];

}

- (void)changeTextLabel {

    float widthIs =
    [[NSString stringWithFormat:@"%i/%i", step, nbStep] boundingRectWithSize:self.captaTitleLabel.frame.size
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{ NSFontAttributeName:self.captaTitleLabel.font }
                                                                     context:nil].size.width;

    [self.constraintTitleView setConstant:widthIs + 8];
    [self.explainLabel setText:[explainArray[step-1] uppercaseString]];
    [baseView addLineHeight:1.4 Label:self.explainLabel];
    [self.captaTitleLabel setText:[NSString stringWithFormat:@"%i/%i  %@", step, nbStep, titleArray[step-1]]];

}

- (void)displayingSynchro {

    [self.loaderImageView setTransform:CGAffineTransformMakeTranslation(0, translationLoader)];
    [self.synchroniseLabel setTransform:CGAffineTransformMakeTranslation(0, translationLoader)];

    [UIView animateWithDuration:duration delay:0 options:0 animations:^{

        [self.loaderImageView setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [self.synchroniseLabel setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [self.loaderImageView setAlpha:1];
        [self.synchroniseLabel setAlpha:1];

    } completion:nil];

}

- (void)hideingSynchro {

    [UIView animateWithDuration:duration delay:0 options:0 animations:^{

        [self.loaderImageView setTransform:CGAffineTransformMakeTranslation(-translation, 0)];
        [self.synchroniseLabel setTransform:CGAffineTransformMakeTranslation(-translation, 0)];
        [self.loaderImageView setAlpha:0];
        [self.synchroniseLabel setAlpha:0];

    } completion:^(BOOL finished){

        [self.loaderImageView setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [self.synchroniseLabel setTransform:CGAffineTransformMakeTranslation(0, 0)];

    }];
    
}

- (void)selectDay {

    [self animatedView:self.captaTitleLabel Duration:duration Delay:0 Alpha:0 Translaton:-translation];
    [self animatedView:self.learnLabel Duration:duration Delay:0 Alpha:0 Translaton:0];
    [self animatedView:self.titleView Duration:duration Delay:0 Alpha:0 Translaton:-translation];
    [self animatedView:self.explainLabel Duration:duration Delay:0 Alpha:0 Translaton:-translation];
    [self animatedView:self.nextButton Duration:duration Delay:0 Alpha:0 Translaton:-translation];
    [self animatedView:self.lineView Duration:duration Delay:0 Alpha:0 Translaton:0];

    [self performSelector:@selector(excuteSegue) withObject:nil afterDelay:duration];

}

- (void)excuteSegue {

    for(UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self performSegueWithIdentifier:@"choose_time" sender:self];

}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

}

- (void)animatedView:(UIView *)view Duration:(float)duration Delay:(float)delay Alpha:(float)alpha Translaton:(int)translation{

    [UIView animateWithDuration:duration delay:delay options:0 animations:^{

        [view setAlpha:alpha];
        [view setTransform:CGAffineTransformMakeTranslation(translation, 0)];

    } completion:nil];
    
    
}

- (void)hideSynchroLabel {

    [self animatedView:self.captaTitleLabel Duration:duration Delay:0 Alpha:0 Translaton:-translation];
    [self animatedView:self.titleView Duration:duration Delay:0 Alpha:0 Translaton:-translation];
    [self animatedView:self.learnLabel Duration:duration Delay:0 Alpha:0 Translaton:-translation];
    [self animatedView:self.explainLabel Duration:duration Delay:0 Alpha:0 Translaton:-translation];
    [self animatedView:self.nextButton Duration:duration Delay:0 Alpha:0 Translaton:-translation];
    [self animatedView:self.lineView Duration:duration Delay:0 Alpha:0 Translaton:0];

    [self animatedView:self.captaTitleLabel Duration:0 Delay:duration Alpha:0 Translaton:translation];
    [self animatedView:self.titleView Duration:0 Delay:duration Alpha:0 Translaton:translation];
    [self animatedView:self.learnLabel Duration:0 Delay:duration Alpha:0 Translaton:translation];
    [self animatedView:self.explainLabel Duration:0 Delay:duration Alpha:0 Translaton:translation];
    [self animatedView:self.nextButton Duration:0 Delay:duration Alpha:0 Translaton:translation];

}

- (void)showSynchroLabel {

    [self animatedView:self.captaTitleLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.titleView Duration:duration Delay:0 Alpha:1 Translaton:0];

}

- (void)sendDataWithSocket:(NSDictionary *)dictionary {

    [self hideingSynchro];
    [self animatedView:self.explainLabel Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.learnLabel Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.lineView Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.nextButton Duration:duration Delay:duration Alpha:1 Translaton:0];

    NSData* myData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];

    [[ApiController sharedInstance] writeDataSocket:jsonString];

}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return NO;
}

- (IBAction)nextAction:(id)sender {

    step++;

    switch (step) {
        case 2:
            [self updateStepLabel];
            if(pedometerIsActive) {
                self.pedometer = [[CMPedometer alloc] init];
                NSDate *now = [[NSDate alloc] init];
                NSDate *startDate = now;
                NSDate *endDate = [startDate dateByAddingTimeInterval:-(24 * 1 * 3600)];

                double delayInSeconds = duration;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

                    [self queryPedometerDataFromDate:endDate toDate:startDate];

                });
            } else {
                [self performSelector:@selector(displayingSynchro) withObject:nil afterDelay:duration];
                [self performSelector:@selector(getPhotos) withObject:nil afterDelay:duration + 0.3];
            }
            break;
        case 3:
            [self updateStepLabel];
            [self performSelector:@selector(startLocation) withObject:nil afterDelay:0.2];
            break;
        case 4:
            if(pedometerIsActive) {
                [self updateStepLabel];
                [self performSelector:@selector(displayingSynchro) withObject:nil afterDelay:duration];
                [self performSelector:@selector(getPhotos) withObject:nil afterDelay:duration + 0.3];
            } else {
                [self selectDay];
            }
            break;
        case 5:
            [self selectDay];
            break;
        default:
            break;
    }

}

@end
