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
    PXAlertView *alert = [PXAlertView showAlertWithTitle:title
                                                 message:msg
                                             cancelTitle:@"OK"
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                              }];

    /** remove corner radius **/
    [alert.view.layer.sublayers[1] setBorderWidth:2.f];
    [alert.view.layer.sublayers[1] setCornerRadius:0];
    [alert.view.layer.sublayers[1] setBorderColor:self.purpleColor.CGColor];
    [alert setWindowTintColor:[self colorWithRGB:0 :0 :0 :0.5]];
    [alert setBackgroundColor:[self colorWithRGB:255 :255 :255 :1]];
    [alert setTitleFont:[UIFont fontWithName:@"MaisonNeue-Light" size:15.0f]];
    [alert setTitleColor:self.purpleColor];
    [alert setMessageColor:self.grey];
    [alert setMessageFont:[UIFont fontWithName:@"MaisonNeue-Light" size:15.0f]];
    [alert setCancelButtonTextColor:self.purpleColor];
//    [alert setCancelButtonBackgroundColor:[UIColor redColor]];

}

@end