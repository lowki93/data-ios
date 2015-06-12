//
//  CaptationImageView.m
//  Data
//
//  Created by kevin Budain on 12/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "CaptationImageView.h"

@implementation CaptationImageView

- (void)initImageView:(CGRect)frame {

    [self setFrame:frame];
    [self setImage:[UIImage imageNamed:@"captation"]];
    [self setContentMode:UIViewContentModeCenter];

    [self scaleView];
    [self executeAnimation];

}

- (void)scaleView {

    [self setTransform:CGAffineTransformIdentity];
    CGAffineTransform informationViewtransform = self.transform;
    [self setTransform:CGAffineTransformScale(informationViewtransform, 0.1, 0.1)];

}

- (void)executeAnimation {

    [self setAlpha:1];

    [UIView animateWithDuration:1 delay:0 options:0 animations:^(void){

        CGAffineTransform informationViewtransform = self.transform;
        [self setTransform:CGAffineTransformScale(informationViewtransform, 35, 35)];

    }completion:nil];

    [UIView animateWithDuration:1 delay:0.5 options:0 animations:^(void){

                [self setAlpha:0];

    }completion:^(bool finished) {

        [self scaleView];
        [self performSelector:@selector(executeAnimation) withObject:nil afterDelay:1];
        
    }];

}

@end
