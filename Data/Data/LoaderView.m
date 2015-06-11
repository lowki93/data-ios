//
//  LoaderView.m
//  Data
//
//  Created by kevin Budain on 11/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "LoaderView.h"
#import "BaseViewController.h"

@implementation LoaderView

BaseViewController *basView;

float firstCircleDuration;

- (void)initView:(CGRect)frame ViewController:(UIViewController *)viewController {

    firstCircleDuration = 0.5;

    basView = [[BaseViewController alloc] init];
    [basView initView:viewController],

    [self setFrame:frame];
    [self setBackgroundColor:[basView colorWithRGB:255 :255 :255 :0]];

    CGPoint circleCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height * 0.5);
    UIBezierPath *firstCirclePath = [UIBezierPath bezierPathWithArcCenter:circleCenter
                                                         radius:self.bounds.size.width / 18.75
                                                     startAngle:-M_PI_2
                                                       endAngle:-M_PI_2 + (M_PI * 2)                                                      clockwise:YES];

    self.firstCircle = [[CAShapeLayer alloc] init];
    [self.firstCircle setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.firstCircle setPath:firstCirclePath.CGPath];
    [self.firstCircle setStrokeColor:[basView colorWithRGB:25 :25 :25 :1].CGColor];
    [self.firstCircle setFillColor:[UIColor clearColor].CGColor];
    [self.firstCircle setLineWidth:1.5f];
    [self.firstCircle setStrokeStart:0/100];
    [self.layer addSublayer:self.firstCircle];

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scaleAnimation setFromValue:[NSNumber numberWithFloat:1.0f]];
    [scaleAnimation setToValue:[NSNumber numberWithFloat:1.4f]];
    [scaleAnimation setDuration:firstCircleDuration];
    [scaleAnimation setRemovedOnCompletion:NO];
    [scaleAnimation setFillMode:kCAFillModeForwards];
    [scaleAnimation setAutoreverses:YES];
    [scaleAnimation setRepeatCount: INFINITY];
    [self.firstCircle addAnimation:scaleAnimation forKey:@"scale"];

    UIBezierPath *secondCirclePath = [UIBezierPath bezierPathWithArcCenter:circleCenter
                                                                   radius:self.bounds.size.width / 2.72
                                                               startAngle:-M_PI_2
                                                                 endAngle:-M_PI_2 + (M_PI * 2) / 3                                                    clockwise:YES];

    self.secondCircle = [[CAShapeLayer alloc] init];
    [self.secondCircle setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.secondCircle setPath:secondCirclePath.CGPath];
    [self.secondCircle setStrokeColor:[basView colorWithRGB:204 :204 :204 :1].CGColor];
    [self.secondCircle setFillColor:[UIColor clearColor].CGColor];
    [self.secondCircle setLineWidth:6.f];
    [self.secondCircle setStrokeStart:0/100];
    [self.layer addSublayer:self.secondCircle];

    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spinAnimation setByValue: [NSNumber numberWithFloat:2.0f * M_PI]];
    [spinAnimation setDuration: 1.3];
    [spinAnimation setRepeatCount: INFINITY];
    [self.secondCircle addAnimation:spinAnimation forKey:@"indeterminateAnimation"];

}


@end
