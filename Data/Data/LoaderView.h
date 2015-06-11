//
//  LoaderView.h
//  Data
//
//  Created by kevin Budain on 11/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaderView : UIView

@property (nonatomic, strong) CAShapeLayer *firstCircle;
@property (nonatomic, strong) CAShapeLayer *secondCircle;

- (void)initView:(CGRect)frame ViewController:(UIViewController *)viewController;


@end
