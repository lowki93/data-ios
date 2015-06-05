//
//  LoaderImageView.m
//  Data
//
//  Created by kevin Budain on 05/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "LoaderImageView.h"

@implementation LoaderImageView

- (void)initImageView {
    [NSThread detachNewThreadSelector:@selector(generateTutorialAnimationImage) toTarget:self withObject:nil];
}

- (void)generateTutorialAnimationImage {

    @autoreleasepool {

        NSMutableArray *imageArray = [[NSMutableArray alloc] init];

        for( int index = 0; index < 40; index++ ){

            NSString *imageName = [NSString stringWithFormat:@"loader_%i.png", index];
            [imageArray addObject:[UIImage imageNamed:imageName]];

        };

        [self setAnimationImages: imageArray];
        [self setAnimationDuration: 1.3];
        [self setAnimationRepeatCount:0];

        [self performSelectorOnMainThread:@selector(addTutorialAnimationImage) withObject:NULL waitUntilDone:NO];
        
    }
    
}

- (void) addTutorialAnimationImage {
    [self startAnimating];
}

@end
