//
//  BaseViewController.m
//  Data
//
//  Created by BUDAIN Kevin on 13/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)initView:(UIViewController *)viewController {
    
    /** color */
    _purpleColor = [self colorWithRGB:28 :32 :73 :1];
    _lightGrey = [self colorWithRGB:237 :237 :237 :1];
    _grey = [self colorWithRGB:166 :168 :170 :1];
    _lightBlue = [self colorWithRGB:159 :179 :204 :1];
    _blue = [self colorWithRGB:20 :179 :210 :1];
    _circlePhotoColor = [self colorWithRGB:243 :146 :0 :1];
    _circlegeolocColor = [self colorWithRGB:23 :0 :134 :1];
    _greyTimeLineColor = [self colorWithRGB:204 :204 :204 :1];
    _blackTimeLineColor = [self colorWithRGB:26 :26 :26 :1];

    UIColor *firstColor, *secondColor, *thirdColor, *fourthColor, *fithColor, *sixthColor;
    firstColor = [self colorWithRGB:91 :54 :161 :1];
    secondColor = [self colorWithRGB:95 :57 :164 :1];
    thirdColor = [self colorWithRGB:142 :78 :199 :1];
    fourthColor = [self colorWithRGB:204 :107 :243 :1];
    fithColor = [self colorWithRGB:215 :111 :252 :1];
    sixthColor = [self colorWithRGB:149 :81 :203 :1];
    self.colorLittleActivityArray = [@[firstColor, secondColor, thirdColor, fourthColor, fithColor, sixthColor] mutableCopy];

    firstColor = [self colorWithRGB:0 :130 :143 :1];
    secondColor = [self colorWithRGB:0 :118 :135 :1];
    thirdColor = [self colorWithRGB:0 :170 :168 :1];
    fourthColor = [self colorWithRGB:0 :220 :199 :1];
    fithColor = [self colorWithRGB:0 :233 :208 :1];
    sixthColor = [self colorWithRGB:0 :176 :172 :1];
    self.colorInitialColorArray = [@[firstColor, secondColor, thirdColor, fourthColor, fithColor, sixthColor] mutableCopy];

    firstColor = [self colorWithRGB:248 :52 :0 :1];
    secondColor = [self colorWithRGB:244 :2 :23 :1];
    thirdColor = [self colorWithRGB:251 :92 :0 :1];
    fourthColor = [self colorWithRGB:255 :144 :0 :1];
    fithColor = [self colorWithRGB:255 :134 :0 :1];
    sixthColor = [self colorWithRGB:251 :87 :0 :1];
    self.colorMuchActivityArray = [@[firstColor, secondColor, thirdColor, fourthColor, fithColor, sixthColor] mutableCopy];

    /** color for navigationBar **/
    UINavigationBar *navigationBar = viewController.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    [navigationBar setTranslucent:YES];
}

- (UIColor *)colorWithRGB:(float)red :(float)green :(float)blue :(float)alpha {
    
    return [UIColor colorWithRed:red / 255 green:green / 255 blue:blue / 255 alpha:alpha];
    
}

- (UIImage *)imageWithColor:(UIColor *)color {

    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)alertStatus:(NSString *)msg :(NSString *)title
{
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
//                                                      message:msg
//                                                     delegate:nil
//                                            cancelButtonTitle:@"OK"
//                                            otherButtonTitles:nil];
//
//    [message show];
    PXAlertView *alert = [PXAlertView showAlertWithTitle:title
                                                 message:msg
                                             cancelTitle:@"Ok"
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                              }];

    /** remove corner radius **/
//    [alert.view.layer.sublayers[1] setBorderWidth:2.f];
//    [alert.view.layer.sublayers[1] setCornerRadius:0];
//    [alert.view.layer.sublayers[1] setBorderColor:self.purpleColor.CGColor];
    [alert setWindowTintColor:[self colorWithRGB:0 :0 :0 :0.5]];
    [alert setBackgroundColor:[self colorWithRGB:255 :255 :255 :1]];
    [alert setTitleFont:[UIFont fontWithName:@"MaisonNeue-Medium" size:15.0f]];
    [alert setTitleColor:[self colorWithRGB:39 :37 :37 :1]];
    [alert setMessageColor:[self colorWithRGB:166 :168 :170 :1]];
    [alert setMessageFont:[UIFont fontWithName:@"MaisonNeue-Book" size:15.0f]];
    [alert setCancelButtonTextColor:[self colorWithRGB:29 :29 :27 :1]];
    [alert setCancelButtonBackgroundColor:[self colorWithRGB:166 :168 :170 :1]];

}

- (void)loadLoader:(UIImageView *)loaderImageView View:(UIView *)currentView {

    [NSThread detachNewThreadSelector:@selector(generateTutorialAnimationImage:View:) toTarget:self withObject:[NSArray arrayWithObjects:loaderImageView, currentView, nil]];

}

- (void)generateTutorialAnimationImage:(UIImageView *)imageView View:(UIView *)view {
    @autoreleasepool {

        NSMutableArray *imageArray = [[NSMutableArray alloc] init];

        for( int index = 0; index < 40; index++ ){

            NSString *imageName = [NSString stringWithFormat:@"loader_%i.png", index];
            [imageArray addObject:[UIImage imageNamed:imageName]];

        };

        [imageView setAnimationImages: imageArray];
        [imageView setAnimationDuration: 1.3];
        [imageView setAnimationRepeatCount:0];

        [self performSelectorOnMainThread:@selector(addTutorialAnimationImage:View:) withObject:[NSArray arrayWithObjects:imageView, view, nil] waitUntilDone:NO];

    }

}

- (void)addTutorialAnimationImage:(UIImageView *)imageView View:(UIView *)view {

    [view addSubview:imageView];
    [imageView startAnimating];
    
}

- (void)addLineHeight:(CGFloat)lineHeight Label:(UILabel *)label {

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[label text]];
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineHeightMultiple:lineHeight];
    [paragrahStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragrahStyle
                             range:NSMakeRange(0, [label.text length])];

    [label setAttributedText:attributedString];

}

- (void)showModal:(NSString *)string {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:string];
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    keyWindow.rootViewController = viewController;
    [keyWindow makeKeyAndVisible];

}

@end