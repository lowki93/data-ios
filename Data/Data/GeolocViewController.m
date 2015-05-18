//
//  GeolocViewController.m
//  Data
//
//  Created by kevin Budain on 30/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "GeolocViewController.h"

@interface GeolocViewController ()

@end

int step, nbStep, translation;
float duration;

@implementation GeolocViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    step = 1;
    duration = 0.5f;
    translation = 20;

    if ([CMPedometer isStepCountingAvailable]) {

        nbStep = 4;

    } else {

        nbStep = 3;

    }

    [self animatedView:self.stepLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.captaTitleLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self updateStepLabel];
    [self animatedView:self.stepLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.captaTitleLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    
    self.locationManager = [[CLLocationManager alloc] init];

    if ([CLLocationManager locationServicesEnabled] ) {

        [self.locationManager  setDelegate: self];
        [self.locationManager  setDesiredAccuracy: kCLLocationAccuracyThreeKilometers];
        [self.locationManager  setDistanceFilter: 9999];

        if ([self.locationManager  respondsToSelector:@selector(requestAlwaysAuthorization)] ) {

            [self.locationManager  requestAlwaysAuthorization]; 

        }
        NSLog(@"start location");
        [self.locationManager startUpdatingLocation];
    }

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    [self displayingSynchro:NO];
//    CLLocation *loc = locations.lastObject;

    [self performSelector:@selector(stopTrackerGeoloc) withObject:nil afterDelay:5.0f];

}

- (void)stopTrackerGeoloc {

    [self.locationManager stopUpdatingLocation];
    [self displayingSynchro:YES];
    step++;

    if ([CMPedometer isStepCountingAvailable]) {

        self.pedometer = [[CMPedometer alloc] init];
        [self.captaTitleLabel setText:@"Pedometer"];
        [self updateStepLabel];

    } else {

        [self.captaTitleLabel setText:@"Photo"];
        [self updateStepLabel];
        [self getPhotos];

    }


}

- (void)updateStepLabel {

 [self.stepLabel setText:[NSString stringWithFormat:@"Step %i / %i", step, nbStep]];

}

- (void)displayingSynchro:(BOOL)boolean {

    [self.loaderImageView setHidden:boolean];
    [self.synchroniseLabel setHidden:boolean];
    [self.stepLabel setHidden:!boolean];

}

- (void)getPhotos {

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    // ALAssetsGroupLibrary , ALAssetsGroupSavedPhotos

    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {

        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
         [self displayingSynchro:NO];

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

                    NSLog(@"SEND PHOTO SERVEUR");
                    [self selectDay];

                }
            }
            
        }];

    } failureBlock: ^(NSError *error) {

        NSLog(@"No groups");
        [self selectDay];

    }];

}

- (void)selectDay {

    [self.captaTitleLabel setText:@"Time"];
    [self.stepLabel setText:@"Sélectionne la durée\nde l’experience"];
    [self displayingSynchro:YES];

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

@end
