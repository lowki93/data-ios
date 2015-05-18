//
//  CustomSegue.m
//  Data
//
//  Created by kevin Budain on 18/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "CustomSegue.h"

@implementation CustomSegue

- (void)perform {

    UIView *sourceView = ((UIViewController *)self.sourceViewController).view;
    UIView *destinationView = ((UIViewController *)self.destinationViewController).view;

    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    destinationView.center = CGPointMake(sourceView.center.x + sourceView.frame.size.width,
                                         destinationView.center.y);
    [window insertSubview:destinationView aboveSubview:sourceView];

    destinationView.alpha = 0.9;

    [UIView animateWithDuration:0.4 animations:^{

        destinationView.alpha = 1;

    } completion:^(BOOL finished){

        [[self sourceViewController] presentViewController:[self destinationViewController] animated:NO completion:nil];

    }];
}

@end
