//
//  PlayerView.m
//  Data
//
//  Created by kevin Budain on 10/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

- (void)initPlayer:(NSString *)video View:(UIView *)view {

    [self setFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
    NSURL *videoUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:video ofType:@"mp4"]];
    self.movieViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoUrl];
    [self.movieViewController.moviePlayer setMovieSourceType: MPMovieSourceTypeFile];
    [self.movieViewController.moviePlayer setFullscreen:YES];
    [self.movieViewController.moviePlayer setAllowsAirPlay:YES];
    [self addSubview:self.movieViewController.view];
    [self.movieViewController.moviePlayer setControlStyle:MPMovieControlStyleNone];
    [self.movieViewController.moviePlayer setRepeatMode:MPMovieRepeatModeOne];

}

@end
