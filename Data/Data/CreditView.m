//
//  CreditView.m
//  Data
//
//  Created by kevin Budain on 14/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "CreditView.h"
#import "DataViewController.h"

BaseViewController *baseView;
DataViewController *dataViewController;

float duration;
int translationY;

@implementation CreditView

- (void)initView:(UIViewController *)dataViewController {

    duration = 0.5;
    translationY = 20;

    dataViewController = dataViewController;
    [self.tutorialButton initButton];

    [self firstHideContent];

}

- (void)firstHideContent {

    [self setHidden:YES];
    [baseView animatedView:self Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    for (UIView *view in self.subviews) {

        [baseView animatedView:view Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];

    }

}

- (void)showContent {

    [self setHidden:NO];
    [baseView animatedView:self Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];
    for (UIView *view in self.subviews) {

        [baseView animatedView:view Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];

    }

}

- (void)hideContent {

    [baseView animatedView:self Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    for (UIView *view in self.subviews) {

        [baseView animatedView:view Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];

    }

}

- (IBAction)hideCredits:(id)sender {

    [self hideContent];
    [self performSelector:@selector(firstHideContent) withObject:nil afterDelay:duration];
    
}

@end