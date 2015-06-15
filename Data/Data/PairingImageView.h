//
//  PairingImageView.h
//  Data
//
//  Created by kevin Budain on 15/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PairingImageView : UIImageView

@property (nonatomic) CAShapeLayer *littleCircle1;
@property (nonatomic) CAShapeLayer *littleCircle2;
@property (nonatomic) CAShapeLayer *littleCircle3;
@property (nonatomic) CAShapeLayer *phoneCircle1;
@property (nonatomic) CAShapeLayer *phoneCircle2;
@property (nonatomic) CAShapeLayer *phoneCircle3;

- (void)initImageView:(CGRect)frame;

@end