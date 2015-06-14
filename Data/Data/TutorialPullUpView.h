//
//  TutorialPullUpView.h
//  Data
//
//  Created by kevin Budain on 31/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialPullUpView : UIView

@property (nonatomic) UILabel *informationLabel;
@property (nonatomic) CAShapeLayer *roundLayer;
@property (nonatomic) CAShapeLayer *lineLayer;

- (void)initView:(UIViewController *)viewController;
- (void)startAnimation;

@end
