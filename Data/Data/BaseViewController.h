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

- (void)initView:(UIViewController *)viewController;
- (UIColor *)colorWithRGB:(float)red :(float)green :(float)blue :(float)alpha;
- (UIImage *)imageWithColor:(UIColor *)color;

@end