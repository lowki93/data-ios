//
//  HomeView.m
//  Data
//
//  Created by kevin Budain on 11/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "HomeView.h"
#import "HomeViewController.h"

HomeViewController *homeViewController;
BaseViewController *baseView;

int translationY, translationX;
float duration;

@implementation HomeView

- (void)initView:(UIViewController *)homeViewController {

    homeViewController = homeViewController;
    baseView = [[BaseViewController alloc] init];
    
    translationY = 20;
    translationX = 50;
    duration = 0.5;

    [self.signUpButton initButton];

    [self firstHide];
    [self performSelector:@selector(showContent) withObject:nil afterDelay:duration - 0.2];

}

- (void)firstHide {

    [baseView animatedView:self.logoImageView Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];
    [baseView animatedView:self.informationLabel Duration:0 Delay:0 Alpha:0 TranslationX:translationX TranslationY:0];
    [baseView animatedView:self.loginButton Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];
    [baseView animatedView:self.signUpButton Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];

}

- (void)showContent {

    [baseView animatedView:self.logoImageView Duration:duration Delay:0.1 Alpha:1 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.informationLabel Duration:duration Delay:0.2 Alpha:1 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.loginButton Duration:duration Delay:0.3 Alpha:1 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.signUpButton Duration:duration Delay:0.3 Alpha:1 TranslationX:0 TranslationY:0];
    
}

- (void)hideContent {

    [baseView animatedView:self.logoImageView Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.informationLabel Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.signUpButton Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.loginButton Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];

    [self performSelector:@selector(firstHide) withObject:nil afterDelay:duration];

}

- (IBAction)signupAction:(id)sender {

    [self hideContent];
    [self performSelector:@selector(hideView) withObject:nil afterDelay:duration];

}

- (IBAction)loginAction:(id)sender {

    [self hideContent];
    [self performSelector:@selector(hideView) withObject:nil afterDelay:duration];

}

- (void)hideView {

    [self setHidden:YES];

}

@end
