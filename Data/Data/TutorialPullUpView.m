//
//  TutorialPullUpView.m
//  Data
//
//  Created by kevin Budain on 31/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "TutorialPullUpView.h"
#import "baseViewController.h"

@implementation TutorialPullUpView

BaseViewController *baseView;

int translation, lineHeight;
float duration;

- (void)initView:(UIViewController *)viewController {

    translation = 20;
    duration = 0.6;
    lineHeight = 200;

    for(UIView *view in self.subviews) {
        self.informationLabel = (UILabel *)view;
    }

    baseView = [[BaseViewController alloc] init];
    [baseView initView:viewController];

    [self setFrame:CGRectMake(0, 0, viewController.view.bounds.size.width, viewController.view.bounds.size.height)];

    CGFloat angle = ((M_PI * -M_PI_2 + (M_PI * 2))/ 180);
    CGPoint center = CGPointMake(viewController.view.bounds.size.width / 2, viewController.view.bounds.size.height / 2 + lineHeight);

    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:center
                                                         radius:25
                                                     startAngle:angle
                                                       endAngle:2 * M_PI + angle
                                                      clockwise:YES];

    UIColor *greyCircle = [baseView colorWithRGB:204 :204 :204 :1];
    self.roundLayer = [[CAShapeLayer alloc] init];
    [self.roundLayer setPath:aPath.CGPath];
    [self.roundLayer setStrokeColor:greyCircle.CGColor];
    [self.roundLayer setFillColor:[UIColor clearColor].CGColor];
    [self.roundLayer setLineWidth:2.f];
    [self.roundLayer setOpacity:0];
    [self.roundLayer setStrokeStart:0/100];
    [self.roundLayer setStrokeEnd:100/100];
    [self.layer addSublayer:self.roundLayer];

    UIColor *greyLine = [baseView colorWithRGB:226 :226 :226 :1];
    self.lineLayer = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(self.bounds.size.width / 2,
                                      self.bounds.size.height / 2 + lineHeight)];
    [linePath addLineToPoint:CGPointMake(self.bounds.size.width / 2,
                                         self.bounds.size.height / 2)];
    [self.lineLayer setPath: linePath.CGPath];
    [self.lineLayer setFillColor: nil];
    [self.lineLayer setOpacity: 1.0];
    [self.lineLayer setLineWidth:3.f];
    [self.lineLayer setStrokeStart:0/100];
    [self.lineLayer setStrokeEnd:0/100];
    [self.lineLayer setStrokeColor: greyLine.CGColor];
    [self.layer addSublayer:self.lineLayer];

    [self setBackgroundColor:[baseView colorWithRGB:255 :255 :255 :0.8]];

    [self animatedView:self.informationLabel Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:translation];

}

- (void)animatedHeightLineLayer {

    [CATransaction begin];
    CABasicAnimation *animateStrokeDown = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [animateStrokeDown setBeginTime: CACurrentMediaTime() + duration * 3];
    [animateStrokeDown setFromValue:[NSNumber numberWithFloat:0/100.]];
    [animateStrokeDown setToValue:[NSNumber numberWithFloat:100/100.]];
    [animateStrokeDown setDuration:duration];
    [animateStrokeDown setFillMode:kCAFillModeForwards];
    [animateStrokeDown setRemovedOnCompletion:NO];
    [self.lineLayer addAnimation:animateStrokeDown forKey:@"strokeEnd"];
    [CATransaction commit];

}

- (void)startAnimation {

    [self animatedView:self.informationLabel Duration:duration Delay:0 Alpha:1 TranslationX:0 TranslationY:0];

    [self animatedOpacityLayer:self.roundLayer Begin:0 End:1 Delay:2];

    [self moveLayer:self.roundLayer];
    [self animatedHeightLineLayer];

    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:duration * 4.5];

}

- (void)stopAnimation {

    [self animatedOpacityLayer:self.roundLayer Begin:1 End:0 Delay:0];
    [self animatedOpacityLayer:self.lineLayer Begin:1 End:0 Delay:0];

}

- (void)moveLayer:(CALayer *)layer {

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setBeginTime: CACurrentMediaTime() + duration * 3];
    [animation setFromValue:[NSValue valueWithCGPoint:[layer position]]];
    [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(0, -lineHeight)]];
    [animation setFillMode: kCAFillModeForwards];
    [animation setDuration:duration];
    [animation setRemovedOnCompletion:NO];
    [layer addAnimation:animation forKey:@"position"];

}

- (void)animatedOpacityLayer:(CALayer *)layer Begin:(float)begin End:(float)end Delay:(float)delay {

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacityAnimation   setBeginTime: CACurrentMediaTime() + duration * delay];
    [opacityAnimation setFromValue: [NSNumber numberWithFloat:begin]];
    [opacityAnimation setToValue: [NSNumber numberWithFloat:end]];
    [opacityAnimation setDuration: duration];
    [opacityAnimation setFillMode:kCAFillModeForwards];
    [opacityAnimation setRemovedOnCompletion:NO];

    [layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];

}

- (void)animatedView:(UIView *)view Duration:(float)duration Delay:(float)delay Alpha:(float)alpha TranslationX:(int)translationX TranslationY:(int)translationY{

    [UIView animateWithDuration:duration delay:delay options:0 animations:^{

        [view setAlpha:alpha];
        [view setTransform:CGAffineTransformMakeTranslation(translationX, translationY)];

    } completion:nil];
    
}

@end
