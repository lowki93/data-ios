//
//  customPageControl.m
//  Data
//
//  Created by kevin Budain on 04/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "customPageControl.h"
#import "baseViewController.h"

BaseViewController *baseView;

@implementation customPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) updateDots {

    for (int i = 0; i < [self.subviews count]; i++) {

        UIView* dotView = [self.subviews objectAtIndex:i];
        [dotView.layer setCornerRadius:dotView.frame.size.height / 2.];
        if (i == self.currentPage) {
            [dotView setBackgroundColor:[baseView colorWithRGB:146 :148 :150 :1]];
            [dotView.layer setBorderColor:[UIColor clearColor].CGColor];
        } else {
            [dotView.layer setBorderColor:[baseView colorWithRGB:208 :209 :211 :1].CGColor];
            [dotView.layer setBorderWidth:1];
        }

    }

}

-(void) setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self updateDots];
}

@end
