//
//  SplashScreenViewController.m
//  Data
//
//  Created by kevin Budain on 06/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "BaseViewController.h"

@interface SplashScreenViewController ()

@end

BaseViewController *baseView;

float duration;

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    duration = 4;
    [UIView animateWithDuration:1 delay:0 options:0 animations:^{

        [self.playerView setAlpha:1];

    } completion:nil];

    [self.playerView initPlayer:@"splash_screen" View:self.view];
    [self performSelector:@selector(goToHome) withObject:nil afterDelay:duration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)goToHome {
    [self.view setBackgroundColor:[baseView colorWithRGB:240 :247 :247 :1]];
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{

        [self.playerView setAlpha:0];

    } completion:^(BOOL finished){

        [self.playerView removeFromSuperview];
        [self performSegueWithIdentifier:@"splash_home" sender:self];

    }];
}


@end
