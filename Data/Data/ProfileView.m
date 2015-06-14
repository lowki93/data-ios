//
//  ProfileVIew.m
//  Data
//
//  Created by kevin Budain on 14/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "ProfileView.h"
#import "DataViewController.h"
#import "BaseViewController.h"

@implementation ProfileView

BaseViewController *baseView;
DataViewController *dataViewController;

float duration;
int translationY;

- (void)initView:(UIViewController *)dataViewController {

    dataViewController = dataViewController;

    duration = 0.5;
    translationY = 20;

    [self.logoutButton initButton];
    [self.editButton initButton];

    [self firstHideContent];

}

- (void)firstHideContent {

    [self setHidden:YES];
    [baseView animatedView:self Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    for (UIView *view in self.subviews) {

        if ([view isKindOfClass:[LineView class]]) {
            [baseView animatedView:view Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
        } else {
            [baseView animatedView:view Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];
        }
        
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

- (IBAction)hideProfile:(id)sender {

    [self hideContent];
    [self performSelector:@selector(firstHideContent) withObject:nil afterDelay:duration];

}

@end