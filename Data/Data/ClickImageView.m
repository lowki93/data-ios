//
//  ClickImageView.m
//  Data
//
//  Created by kevin Budain on 05/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "ClickImageView.h"

@implementation ClickImageView

float heightViewController, widthViewController;

- (void)initImageView:(UIView *)view {
    heightViewController = view.bounds.size.height;
    widthViewController = view.bounds.size.width;
    [NSThread detachNewThreadSelector:@selector(generateClickAnimationImage) toTarget:self withObject:nil];
}

- (void)generateClickAnimationImage {

    @autoreleasepool {

        NSMutableArray *imageArray = [[NSMutableArray alloc] init];

        for( int index = 0; index < 38; index++ ){

            NSString *imageName = [NSString stringWithFormat:@"clic_0_%i.png", index];
            [imageArray addObject:[UIImage imageNamed:imageName]];

        };

        [self setAnimationImages:imageArray];
        [self setAnimationDuration:2];
        [self setAnimationRepeatCount:0];

        [self performSelectorOnMainThread:@selector(addClickAnimationImage) withObject:NULL waitUntilDone:NO];

    }

}

- (void)addClickAnimationImage {

    [UIView animateWithDuration:0.5  delay:0  options:0 animations:^{

        [self setAlpha:1];

    } completion:nil];
    [self startAnimating];

    [self performSelector:@selector(removeButtonSelector) withObject:nil afterDelay:3.5];
    
}

- (void)removeButtonSelector {

    [UIView animateWithDuration:0.5  delay:0.3  options:0 animations:^{

        [self setAlpha:0];

    } completion:^(BOOL finished){

        int width = 100;
        [self setFrame:CGRectMake((widthViewController / 2) - (width / 2),
                                  (heightViewController / 2) - (width / 2),
                                  width,
                                  width)];

        
    }];
    
}
@end
