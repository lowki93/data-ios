//
//  SplashScreenViewController.m
//  Data
//
//  Created by kevin Budain on 06/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()

@end

float duration;

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    duration = 4;
     [NSThread detachNewThreadSelector:@selector(generateTutorialAnimationImage) toTarget:self withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)generateTutorialAnimationImage {

    @autoreleasepool {

        NSMutableArray *imageArray = [[NSMutableArray alloc] init];

        for( int index = 0; index < 92; index++ ){

            NSString *imageName = [NSString stringWithFormat:@"splashscreen_%iX2.png", index];
            [imageArray addObject:[UIImage imageNamed:imageName]];

        };

        [self.splashScreenImageView setAnimationImages: imageArray];
        [self.splashScreenImageView setAnimationDuration: duration];
        [self.splashScreenImageView setAnimationRepeatCount:1];

        [self performSelectorOnMainThread:@selector(addTutorialAnimationImage) withObject:NULL waitUntilDone:NO];
    }

}

- (void) addTutorialAnimationImage {
    [self.splashScreenImageView startAnimating];
    [self performSelector:@selector(goToHome) withObject:nil afterDelay:duration + 0.5];
}

- (void)goToHome {
    [self performSegueWithIdentifier:@"splash_home" sender:self];
}


@end
