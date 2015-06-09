//
//  GroundImageView.m
//  Data
//
//  Created by kevin Budain on 08/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "GroundImageView.h"

@implementation GroundImageView

- (void)initImageView {
    [NSThread detachNewThreadSelector:@selector(generateGroundAnimationImage) toTarget:self withObject:nil];
}

- (void)generateGroundAnimationImage {

    @autoreleasepool {

        NSMutableArray *imageArray = [[NSMutableArray alloc] init];

        for( int index = 0; index < 107; index++ ){

            NSString *imageName = [NSString stringWithFormat:@"ground_%i.png", index];
            [imageArray addObject:[UIImage imageNamed:imageName]];
//            index = index;
        };

        [self setAnimationImages: imageArray];
        [self setAnimationDuration:5.16];
        [self setAnimationRepeatCount:0];

        [self performSelectorOnMainThread:@selector(addGroundAnimationImage) withObject:NULL waitUntilDone:NO];

    }

}

- (void) addGroundAnimationImage {
    [self startAnimating];
}

@end
