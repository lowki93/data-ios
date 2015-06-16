//
//  BaseViewController.h
//  Data
//
//  Created by BUDAIN Kevin on 13/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property(retain, nonatomic) UIColor *purpleColor;
@property(retain, nonatomic) UIColor *lightGrey;
@property(retain, nonatomic) UIColor *grey;
@property(retain, nonatomic) UIColor *lightBlue;
@property(retain, nonatomic) UIColor *blue;
@property(retain, nonatomic) UIColor *circlePhotoColor;
@property(retain, nonatomic) UIColor *circlegeolocColor;
@property(retain, nonatomic) UIColor *greyTimeLineColor;
@property(retain, nonatomic) UIColor *blackTimeLineColor;
@property(nonatomic) NSMutableArray *colorTutorialArray;
@property(nonatomic) NSMutableArray *colorLittleActivityArray;
@property(nonatomic) NSMutableArray *colorInitialColorArray;
@property(nonatomic) NSMutableArray *colorMuchActivityArray;

- (void)initView:(UIViewController *)viewController;
- (UIColor *)colorWithRGB:(float)red :(float)green :(float)blue :(float)alpha;
- (UIImage *)imageWithColor:(UIColor *)color;
- (void)alertStatus:(NSString *)msg :(NSString *)title;
- (void)addLineHeight:(CGFloat)lineHeight Label:(UILabel *)label;
- (void)showModal:(NSString *)string RemoveWindow:(BOOL)remove;
- (void)animatedView:(UIView *)view
            Duration:(float)duration
               Delay:(float)delay
               Alpha:(float)alpha
        TranslationX:(int)translationX
        TranslationY:(int)translationY;

@end