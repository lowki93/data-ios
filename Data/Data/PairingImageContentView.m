//
//  PairingImageContentView.m
//  Data
//
//  Created by kevin Budain on 16/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "PairingImageContentView.h"

BaseViewController *baseView;
float duration,delay;

@implementation PairingImageContentView

- (void)initView:(CGRect)frame {

    [self setFrame:frame];
    [self setBackgroundColor:[baseView colorWithRGB:255 :255 :255 :0]];

    duration = 0.5;
    delay = 0.5;

    UIColor *littleCircleColor = [baseView colorWithRGB:25 :25 :25 :1];
    UIColor *phoneCircleColor = [baseView colorWithRGB:204 :204 :204 :1];
    float radiusLittleCircle = self.bounds.size.width / 166.67;
    float radiusPhoneCircle = self.bounds.size.width / 9.26;
    float lineWidthLittleCircle = self.bounds.size.width / (self.bounds.size.width * 2);
    float lineWidthPhoneCircle = self.bounds.size.width / 83.33;

    CGFloat angle = ((M_PI * -M_PI_2 + (M_PI * 2))/ 180);
    CGPoint circle1 = CGPointMake(frame.size.width * 0.37, (frame.size.height / 2) - (radiusLittleCircle / 2) );

    UIBezierPath *circle1Path = [UIBezierPath bezierPathWithArcCenter:circle1
                                                               radius:radiusLittleCircle
                                                           startAngle:angle
                                                             endAngle:2 * M_PI + angle
                                                            clockwise:YES];

    self.littleCircle1 = [[CAShapeLayer alloc] init];
    [self.littleCircle1 setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.littleCircle1 setPath:circle1Path.CGPath];
    [self.littleCircle1 setStrokeColor:littleCircleColor.CGColor];
    [self.littleCircle1 setFillColor:littleCircleColor.CGColor];
    [self.littleCircle1 setLineWidth: lineWidthLittleCircle];
    [self.littleCircle1 setStrokeStart:0/100];
    [self.littleCircle1 setStrokeEnd:100/100];
    [self.littleCircle1 setOpacity:0];
    [self.layer addSublayer:self.littleCircle1];

    CGPoint circle2 = CGPointMake(frame.size.width * 0.42, (frame.size.height / 2) - (radiusLittleCircle / 2) );
    UIBezierPath *circle2Path = [UIBezierPath bezierPathWithArcCenter:circle2
                                                               radius:radiusLittleCircle
                                                           startAngle:angle
                                                             endAngle:2 * M_PI + angle
                                                            clockwise:YES];

    self.littleCircle2 = [[CAShapeLayer alloc] init];
    [self.littleCircle2 setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.littleCircle2 setPath:circle2Path.CGPath];
    [self.littleCircle2 setStrokeColor:littleCircleColor.CGColor];
    [self.littleCircle2 setFillColor:littleCircleColor.CGColor];
    [self.littleCircle2 setLineWidth: lineWidthLittleCircle];
    [self.littleCircle2 setStrokeStart:0/100];
    [self.littleCircle2 setStrokeEnd:100/100];
    [self.littleCircle2 setOpacity:0];
    [self.layer addSublayer:self.littleCircle2];

    CGPoint circle3 = CGPointMake(frame.size.width * 0.47, (frame.size.height / 2) - (radiusLittleCircle / 2) );
    UIBezierPath *circle3Path = [UIBezierPath bezierPathWithArcCenter:circle3
                                                               radius:radiusLittleCircle
                                                           startAngle:angle
                                                             endAngle:2 * M_PI + angle
                                                            clockwise:YES];

    self.littleCircle3 = [[CAShapeLayer alloc] init];
    [self.littleCircle3 setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.littleCircle3 setPath:circle3Path.CGPath];
    [self.littleCircle3 setStrokeColor:littleCircleColor.CGColor];
    [self.littleCircle3 setFillColor:littleCircleColor.CGColor];
    [self.littleCircle3 setLineWidth: lineWidthLittleCircle];
    [self.littleCircle3 setStrokeStart:0/100];
    [self.littleCircle3 setStrokeEnd:100/100];
    [self.littleCircle3 setOpacity:0];
    [self.layer addSublayer:self.littleCircle3];

    CGPoint phoneCircle1 = CGPointMake(radiusPhoneCircle, radiusPhoneCircle);

    UIBezierPath *phoneCircle1Path = [UIBezierPath bezierPathWithArcCenter:phoneCircle1
                                                                    radius:radiusPhoneCircle
                                                                startAngle:angle
                                                                  endAngle:2 * M_PI + angle
                                                                 clockwise:YES];

    self.phoneCircle1 = [[CAShapeLayer alloc] init];
    [self.phoneCircle1 setFrame:CGRectMake((frame.size.width * 0.19) - radiusPhoneCircle,
                                           (frame.size.height / 2) - radiusPhoneCircle,
                                           radiusPhoneCircle * 2,
                                           radiusPhoneCircle * 2)];
    [self.phoneCircle1 setPath:phoneCircle1Path.CGPath];
    [self.phoneCircle1 setStrokeColor:phoneCircleColor.CGColor];
    [self.phoneCircle1 setFillColor:[UIColor clearColor].CGColor];
    [self.phoneCircle1 setLineWidth: lineWidthPhoneCircle];
    [self.phoneCircle1 setStrokeStart:0/100];
    [self.phoneCircle1 setStrokeEnd:100/100];
    [self.layer addSublayer:self.phoneCircle1];

    UIBezierPath *phoneCircle2Path = [UIBezierPath bezierPathWithArcCenter:phoneCircle1
                                                                    radius:radiusPhoneCircle
                                                                startAngle:angle
                                                                  endAngle:2 * M_PI + angle
                                                                 clockwise:YES];

    self.phoneCircle2 = [[CAShapeLayer alloc] init];
    [self.phoneCircle2 setFrame:CGRectMake((frame.size.width * 0.19) - radiusPhoneCircle,
                                           (frame.size.height / 2) - radiusPhoneCircle,
                                           radiusPhoneCircle * 2,
                                           radiusPhoneCircle * 2)];
    [self.phoneCircle2 setPath:phoneCircle2Path.CGPath];
    [self.phoneCircle2 setStrokeColor:phoneCircleColor.CGColor];
    [self.phoneCircle2 setFillColor:[UIColor clearColor].CGColor];
    [self.phoneCircle2 setLineWidth: lineWidthPhoneCircle];
    [self.phoneCircle2 setStrokeStart:0/100];
    [self.phoneCircle2 setStrokeEnd:100/100];
    [self.layer addSublayer:self.phoneCircle2];

    UIBezierPath *phoneCircle3Path = [UIBezierPath bezierPathWithArcCenter:phoneCircle1
                                                                    radius:radiusPhoneCircle
                                                                startAngle:angle
                                                                  endAngle:2 * M_PI + angle
                                                                 clockwise:YES];

    self.phoneCircle3 = [[CAShapeLayer alloc] init];
    [self.phoneCircle3 setFrame:CGRectMake((frame.size.width * 0.19) - radiusPhoneCircle,
                                           (frame.size.height / 2) - radiusPhoneCircle,
                                           radiusPhoneCircle * 2,
                                           radiusPhoneCircle * 2)];
    [self.phoneCircle3 setPath:phoneCircle3Path.CGPath];
    [self.phoneCircle3 setStrokeColor:phoneCircleColor.CGColor];
    [self.phoneCircle3 setFillColor:[UIColor clearColor].CGColor];
    [self.phoneCircle3 setLineWidth: lineWidthPhoneCircle];
    [self.phoneCircle3 setStrokeStart:0/100];
    [self.phoneCircle3 setStrokeEnd:100/100];
    [self.layer addSublayer:self.phoneCircle3];

    [self scaleLayer:self.phoneCircle1 FirstScale:0 SecondeScale:0 Duration:0];
    [self scaleLayer:self.phoneCircle2 FirstScale:0 SecondeScale:0 Duration:0];
    [self scaleLayer:self.phoneCircle3 FirstScale:0 SecondeScale:0 Duration:0];

    [self animatePhoneCircle:self.phoneCircle1];
    [self performSelector:@selector(animatePhoneCircle:) withObject:self.phoneCircle2 afterDelay:1];
    [self performSelector:@selector(animatePhoneCircle:) withObject:self.phoneCircle3 afterDelay:2];

    [self firstOpacityLittleCircle];

    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"pairingAnimation"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:imageView];

}

- (void)animatePhoneCircle:(CALayer *)layer {

    [self scaleLayer:layer FirstScale:0 SecondeScale:1 Duration:3];
    [self animateOpacityLayer:layer Duration:2.4 Delay:0.6 BeginAlpha:1 EndAlpha:0 Name:@"opaticy"];

    [self performSelector:@selector(animatePhoneCircle:) withObject:layer afterDelay:3];

}

- (void)firstOpacityLittleCircle {

    [self animateOpacityLayer:self.littleCircle1 Duration:duration Delay:0 BeginAlpha:0 EndAlpha:1 Name:@"firstOpaticy"];
    [self animateOpacityLayer:self.littleCircle2 Duration:duration Delay:delay BeginAlpha:0 EndAlpha:1 Name:@"firstOpaticy"];
    [self animateOpacityLayer:self.littleCircle3 Duration:duration Delay:delay * 2 BeginAlpha:0 EndAlpha:1 Name:@"firstOpaticy"];

    [self performSelector:@selector(removeFirstOpacityLittleCircle) withObject:nil afterDelay:delay * 3];

}

- (void)removeFirstOpacityLittleCircle {


    [self animateOpacityLayer:self.littleCircle1 Duration:duration Delay:0 BeginAlpha:1 EndAlpha:0 Name:@"removeFirstOpaticy"];
    [self animateOpacityLayer:self.littleCircle2 Duration:duration Delay:delay BeginAlpha:1 EndAlpha:0 Name:@"removeFirstOpaticy"];
    [self animateOpacityLayer:self.littleCircle3 Duration:duration Delay:delay * 2 BeginAlpha:1 EndAlpha:0 Name:@"removeFirstOpaticy"];

    [self performSelector:@selector(secondOpacityLittleCircle) withObject:nil afterDelay:delay * 4];

}

- (void)secondOpacityLittleCircle {

    [self animateOpacityLayer:self.littleCircle3 Duration:duration Delay:0 BeginAlpha:0 EndAlpha:1 Name:@"secondOpaticy"];
    [self animateOpacityLayer:self.littleCircle2 Duration:duration Delay:delay BeginAlpha:0 EndAlpha:1 Name:@"secondOpaticy"];
    [self animateOpacityLayer:self.littleCircle1 Duration:duration Delay:delay * 2 BeginAlpha:0 EndAlpha:1 Name:@"secondOpaticy"];

    [self performSelector:@selector(removeSecondOpacityLittleCircle) withObject:nil afterDelay:delay * 3];

}

- (void)removeSecondOpacityLittleCircle {


    [self animateOpacityLayer:self.littleCircle3 Duration:duration Delay:0 BeginAlpha:1 EndAlpha:0 Name:@"removeSecondOpaticy"];
    [self animateOpacityLayer:self.littleCircle2 Duration:duration Delay:delay BeginAlpha:1 EndAlpha:0 Name:@"removeSecondOpaticy"];
    [self animateOpacityLayer:self.littleCircle1 Duration:duration Delay:delay * 2 BeginAlpha:1 EndAlpha:0 Name:@"removeSecondOpaticy"];

    [self performSelector:@selector(removeAllAnimations) withObject:nil afterDelay:delay * 4];

}

- (void)animateOpacityLayer:(CALayer *)layer Duration:(float)duration Delay:(float)delay BeginAlpha:(float)firstAlpha EndAlpha:(float)secondAlpha Name:(NSString *)animationName {

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacityAnimation setBeginTime: CACurrentMediaTime() + delay];
    [opacityAnimation setToValue: [NSNumber numberWithFloat:secondAlpha]];
    [opacityAnimation setDuration: duration];
    [opacityAnimation setFillMode:kCAFillModeForwards];
    [opacityAnimation setRemovedOnCompletion:NO];
    [layer addAnimation:opacityAnimation forKey:animationName];

}

- (void)scaleLayer:(CALayer *)layer FirstScale:(float)firstScale SecondeScale:(float)secondScale Duration:(float)duration {

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scaleAnimation setFromValue:[NSNumber numberWithFloat:firstScale]];
    [scaleAnimation setToValue:[NSNumber numberWithFloat:secondScale]];
    [scaleAnimation setDuration:duration];
    [scaleAnimation setRemovedOnCompletion:NO];
    [scaleAnimation setFillMode:kCAFillModeForwards];
    [scaleAnimation setAutoreverses:NO];
    [layer addAnimation:scaleAnimation forKey:@"scale"];

}

- (void)removeAllAnimations {
    
    [self.littleCircle1 removeAllAnimations];
    [self.littleCircle2 removeAllAnimations];
    [self.littleCircle3 removeAllAnimations];
    [self firstOpacityLittleCircle];
    
}

@end
