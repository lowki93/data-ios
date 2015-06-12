//
//  SignUpView.m
//  Data
//
//  Created by kevin Budain on 12/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "SignUpView.h"
#import "HomeViewController.h"
#import "AFHTTPRequestOperationManager.h"

@implementation SignUpView

HomeViewController *testController;
BaseViewController *baseView;

int translationY, translationX;
float duration;

- (void)initView:(UIViewController *)homeViewController {

    homeViewController = homeViewController;
    baseView = [[BaseViewController alloc] init];

    translationY = 20;
    translationX = 50;
    duration = 0.5;

    [self.signUpButton initButton];

    [self firstHide];

}

- (void)firstHide {

    [baseView animatedView:self.titleLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];
    [baseView animatedView:self.mailTextField Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];
    [baseView animatedView:self.confirmationPasswordTextField Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];
    [baseView animatedView:self.loginButton Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];
    [baseView animatedView:self.usernameTextField Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];
    [baseView animatedView:self.passwordTextField Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];
    [baseView animatedView:self.loginButton Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];
    [baseView animatedView:self.lineView Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.informationLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];
    [baseView animatedView:self.signUpButton Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];

}

- (void)showContent {

    [baseView animatedView:self.titleLabel Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.mailTextField Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.confirmationPasswordTextField Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.loginButton Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.usernameTextField Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.passwordTextField Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.loginButton Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.lineView Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.informationLabel Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.signUpButton Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];

}

- (void)hideContent {

    [baseView animatedView:self.titleLabel Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.mailTextField Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.confirmationPasswordTextField Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.loginButton Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.usernameTextField Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.passwordTextField Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.loginButton Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.lineView Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.informationLabel Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.signUpButton Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];

    [self performSelector:@selector(firstHide) withObject:nil afterDelay:duration];
    
}

- (IBAction)backgroundTap:(id)sender {

     [self endEditing:YES];

}

- (IBAction)loginAction:(id)sender {
    
    [self hideContent];
    [self performSelector:@selector(hideView) withObject:nil afterDelay:duration];

}

- (void)hideView {

    [self setHidden:YES];
    
}

@end
