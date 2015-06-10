//
//  PlayerView.h
//  Data
//
//  Created by kevin Budain on 10/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerView : UIView

@property (nonatomic) MPMoviePlayerViewController *movieViewController;

-(void)initPlayer:(NSString *)video View:(UIView *)view;

@end
