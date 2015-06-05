//
//  CaptionImageView.m
//  Data
//
//  Created by kevin Budain on 05/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "CaptionImageView.h"

@implementation CaptionImageView

- (void)initImageView {
    [NSThread detachNewThreadSelector:@selector(generateCaptionLoaderAnimationImage) toTarget:self withObject:nil];
}

- (void)generateCaptionLoaderAnimationImage {

    @autoreleasepool {

        NSMutableArray *imageArray = [[NSMutableArray alloc] init];

        for( int index = 0; index < 79; index++ ){

            NSString *imageName = [NSString stringWithFormat:@"captation_%i.png", index];
            [imageArray addObject:[UIImage imageNamed:imageName]];

        };

        [self setAnimationImages:imageArray];
        [self setAnimationDuration:4];
        [self setAnimationRepeatCount:0];

        [self performSelectorOnMainThread:@selector(addTutorialAnimationImage) withObject:NULL waitUntilDone:NO];

    }

}

- (void)addTutorialAnimationImage {

    [self startAnimating];
    [self setHidden:NO];
    
}

@end
