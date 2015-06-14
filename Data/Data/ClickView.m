//
//  ClickView.m
//  Data
//
//  Created by kevin Budain on 13/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "ClickView.h"
#import "BaseViewController.h"

@implementation ClickView

BaseViewController *baseView;

- (void)initView:(CGRect)frame {

    [self setFrame:frame];

    CGFloat angle = ((M_PI * -M_PI_2 + (M_PI * 2))/ 180);
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);

    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:center
                                                         radius:self.bounds.size.width / 2 - 7
                                                     startAngle:angle
                                                       endAngle:2 * M_PI + angle
                                                      clockwise:YES];

    UIColor *greyCircle = [baseView colorWithRGB:204 :204 :204 :1];
    self.roundLayer = [[CAShapeLayer alloc] init];
    [self.roundLayer setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.roundLayer setPath:aPath.CGPath];
    [self.roundLayer setStrokeColor:greyCircle.CGColor];
    [self.roundLayer setFillColor:[UIColor clearColor].CGColor];
    [self.roundLayer setLineWidth: frame.size.width / 14.28f];
    [self.roundLayer setStrokeStart:0/100];
    [self.roundLayer setStrokeEnd:100/100];
    [self.layer addSublayer:self.roundLayer];

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scaleAnimation setFromValue:[NSNumber numberWithFloat:0.6f]];
    [scaleAnimation setToValue:[NSNumber numberWithFloat:0.6]];
    [scaleAnimation setDuration:0];
    [scaleAnimation setRemovedOnCompletion:NO];
    [scaleAnimation setFillMode:kCAFillModeForwards];
    [self.roundLayer addAnimation:scaleAnimation forKey:@"scale"];

    [self scaleAnimation];

}

- (void)scaleAnimation {

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scaleAnimation setFromValue:[NSNumber numberWithFloat:0.6f]];
    [scaleAnimation setToValue:[NSNumber numberWithFloat:1]];
    [scaleAnimation setDuration:0.4];
    [scaleAnimation setRemovedOnCompletion:NO];
    [scaleAnimation setFillMode:kCAFillModeForwards];
    [scaleAnimation setAutoreverses:YES];
    [self.roundLayer addAnimation:scaleAnimation forKey:@"scale"];

    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    [drawAnimation setBeginTime:CACurrentMediaTime() + 0.8];
    [drawAnimation setDuration: 0.4];
    [drawAnimation setFromValue: [NSNumber numberWithFloat:5]];
    [drawAnimation setToValue: [NSNumber numberWithFloat:10]];
    [drawAnimation setRemovedOnCompletion:NO];
    [drawAnimation setFillMode:kCAFillModeForwards];
    [drawAnimation setAutoreverses:YES];
    [self.roundLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];

    [self performSelector:@selector(scaleAnimation) withObject:nil afterDelay:1.65];

}

- (void)removeButtonSelector:(UIView *)view {

    [UIView animateWithDuration:0.5  delay:0.3  options:0 animations:^{

        [self setAlpha:0];

    } completion:^(BOOL finished){

        int width = 100;
        CGRect newFrame = CGRectMake((view.bounds.size.width/ 2) - (width / 2),
                                      (view.bounds.size.height / 2) - (width / 2),
                                      width,
                                      width);

        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scaleAnimation) object:nil];
        [self setFrame:newFrame];
        [self.roundLayer removeAllAnimations];
        for (CALayer *layer in self.layer.sublayers) {
            [layer removeFromSuperlayer];
        }
        [self initView:newFrame];
        
    }];
    
}

@end
