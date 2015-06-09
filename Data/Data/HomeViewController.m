//
//  HomeViewController.m
//  Data
//
//  Created by kevin Budain on 05/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "HomeViewController.h"
#import "BaseViewController.h"

@interface HomeViewController ()

@end

BaseViewController *baseView;
float duration;
int translationX, translationY;

@implementation HomeViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    duration = 0.5;
    translationX = 50;
    translationY = 20;

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    [baseView addLineHeight:1.4 Label:self.informationLabel];
    [self.informationLabel setTextAlignment:NSTextAlignmentLeft];

    [self.signUpButton initButton];

    [self animatedView:self.backgroundImageView Duration:0 Delay:0 Alpha:0 TranslationX:translationX TranslationY:0];
    [self animatedView:self.logoImageView Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];
    [self animatedView:self.informationLabel Duration:0 Delay:0 Alpha:0 TranslationX:translationX TranslationY:0];
    [self animatedView:self.loginButton Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];
    [self animatedView:self.signUpButton Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translationY];

    [self performSelector:@selector(firstAnimation) withObject:nil afterDelay:duration];

}

- (void)firstAnimation {

    [self animatedView:self.backgroundImageView Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.logoImageView Duration:duration Delay:0.1 Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.informationLabel Duration:duration Delay:0.2 Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.loginButton Duration:duration Delay:0.3 Alpha:1 TranslationX:0 TranslationY:0];
    [self animatedView:self.signUpButton Duration:duration Delay:0.3 Alpha:1 TranslationX:0 TranslationY:0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)animatedView:(UIView *)view Duration:(float)duration Delay:(float)delay Alpha:(float)alpha TranslationX:(int)translationX TranslationY:(int)translationY{

    [UIView animateWithDuration:duration delay:delay options:0 animations:^{

        [view setAlpha:alpha];
        [view setTransform:CGAffineTransformMakeTranslation(translationX, translationY)];

    } completion:nil];
    
}

- (IBAction)signupAction:(id)sender {

    [self hideContent];
//    [self performSelector:@selector(segueAfterDelay:) withObject:@"home_signup" afterDelay:duration];
    [self performSelector:@selector(segueAfterDelay:) withObject:@"SignUpViewController" afterDelay:duration];
}

- (IBAction)loginAction:(id)sender {
    [self hideContent];
//    [self performSelector:@selector(segueAfterDelay:) withObject:@"home_login" afterDelay:duration];
    [self performSelector:@selector(segueAfterDelay:) withObject:@"LoginViewController" afterDelay:duration];

}

- (void)hideContent {
    [self animatedView:self.logoImageView Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [self animatedView:self.informationLabel Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [self animatedView:self.signUpButton Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [self animatedView:self.loginButton Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [self animatedView:self.backgroundImageView Duration:duration Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
}

- (void)segueAfterDelay:(NSString *)string {
    [self.backgroundImageView setContentMode:UIViewContentModeBottom];
    [self.backgroundImageView setImage:[UIImage imageNamed:@"background"]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.backgroundImageView setBackgroundColor:[baseView colorWithRGB:242 :247 :248 :1]];
    [self.backgroundImageView initImageView];
    [self animatedView:self.backgroundImageView Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];

    [self.informationLabel removeFromSuperview];
    [self.signUpButton removeFromSuperview];
    [self.loginButton removeFromSuperview];
    [self.logoImageView removeFromSuperview];

//    [self performSegueWithIdentifier:string sender:self];
    [baseView showModal:string];

}

@end
