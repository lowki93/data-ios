//
//  ClickView.h
//  Data
//
//  Created by kevin Budain on 13/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClickView : UIView

@property (nonatomic) CAShapeLayer *roundLayer;

- (void)initView:(CGRect)frame;
- (void)removeButtonSelector:(UIView *)view;

@end
