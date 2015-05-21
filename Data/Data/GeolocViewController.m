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
NSMutableDictionary *pedometerInformation;
NSDictionary *dictionary;
NSString *idString, *tokenString;

int step, nbStep, translation, translationLoader;
float duration;

@implementation GeolocViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    translationLoader =  20;
    [self hideingSynchro];

    step = 1;
    duration = 0.5f;
    translation = 75;

    if ([CMPedometer isStepCountingAvailable]) {

        nbStep = 4;

    } else {

        nbStep = 3;

    }

    idString = [NSString stringWithFormat:@"%@", [ApiController sharedInstance].user._id];
    tokenString = [NSString stringWithFormat:@"%@", [ApiController sharedInstance].user.token];

    [baseView addLineHeight:1.3 Label:self.synchroniseLabel];

    [self animatedView:self.stepLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.captaTitleLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.touLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.learnLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self updateStepLabel];
    [self animatedView:self.stepLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.captaTitleLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.touLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.learnLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];

    if ([CLLocationManager locationServicesEnabled] ) {

        [self.locationManager  setDelegate: self];
        [self.locationManager  setDesiredAccuracy: kCLLocationAccuracyThreeKilometers];
        [self.locationManager  setDistanceFilter: 9999];

        if ([self.locationManager  respondsToSelector:@selector(requestAlwaysAuthorization)] ) {

            [self.locationManager performSelector:@selector(requestAlwaysAuthorization) withObject:nil afterDelay:duration * 2];

        }
        NSLog(@"start location");
        [self.locationManager startUpdatingLocation];
    }

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

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
    [self.locationManager stopUpdatingLocation];

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
        [self performSelector:@selector(stopTrackerGeoloc) withObject:nil afterDelay:5.0f];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self performSelector:@selector(uploadFirstGeoloc:) withObject:[NSArray arrayWithObjects:geolocDictionary, nil] afterDelay:5.0f];
        
    }];

}

- (void)stopTrackerGeoloc {

    [self hideingSynchro];
    step++;

    if ([CMPedometer isStepCountingAvailable]) {

        self.pedometer = [[CMPedometer alloc] init];
        [self hideSynchroLabel];
        [self.captaTitleLabel setText:@"Pedometer"];
        [self updateStepLabel];
        [self showSynchroLabel];

    } else {

        [self hideSynchroLabel];
        [self.captaTitleLabel setText:@"Photo"];
        [self updateStepLabel];
        [self showSynchroLabel];
        [self performSelector:@selector(getPhotos) withObject:nil afterDelay:5.];

    }


}

- (void)updateStepLabel {

 [self.stepLabel setText:[NSString stringWithFormat:@"Step %i / %i", step, nbStep]];

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

- (void)getPhotos {
    NSLog(@"get photos");
    [self displayingSynchro];

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

                    [self performSelector:@selector(selectDay) withObject:nil afterDelay:3];

                }
            }
            
        }];

    } failureBlock: ^(NSError *error) {

        [self performSelector:@selector(selectDay) withObject:nil afterDelay:3];
//
    }];

}

- (void)selectDay {

    [self animatedView:self.stepLabel Duration:duration Delay:duration Alpha:0 Translaton:-translation];
    [self animatedView:self.captaTitleLabel Duration:duration Delay:duration Alpha:0 Translaton:-translation];
    [self hideingSynchro];
    [self animatedView:self.touLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.learnLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * 2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        [self performSegueWithIdentifier:@"choose_time" sender:self];

    });

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

    [self animatedView:self.stepLabel Duration:duration Delay:0 Alpha:0 Translaton:-translation];
    [self animatedView:self.captaTitleLabel Duration:duration Delay:0 Alpha:0 Translaton:-translation];
    [self animatedView:self.touLabel Duration:duration Delay:0 Alpha:0 Translaton:-translation];
    [self animatedView:self.learnLabel Duration:duration Delay:0 Alpha:0 Translaton:-translation];
    [self animatedView:self.stepLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.captaTitleLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.touLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.learnLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];

}

- (void)showSynchroLabel {

    [self animatedView:self.stepLabel Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.captaTitleLabel Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.captaTitleLabel Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.touLabel Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.learnLabel Duration:duration Delay:duration Alpha:1 Translaton:0];

}

@end
