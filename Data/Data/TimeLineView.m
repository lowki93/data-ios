//
//  TimeLineView.m
//  Data
//
//  Created by kevin Budain on 16/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "TimeLineView.h"

@implementation TimeLineView

UISwipeGestureRecognizer *leftGesture, *rightGesture;
CAShapeLayer *progressLayer;
int indexDay;
int nbDay = 13;
int currentDay = 4;
CGFloat endPogressLayer = 0;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    NSLog(@"drawRect");

    leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [leftGesture setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self addGestureRecognizer:leftGesture];

    rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [rightGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self addGestureRecognizer:rightGesture];

    for (int i = 0; i < nbDay + 1; i++) {
        CGFloat theta = ((M_PI * (360.0 / nbDay) * i)/ 180) - M_PI_2 + (M_PI_4 * 0 );
        CGPoint newCenter = CGPointMake(cosf(theta) * 100 + self.bounds.size.width / 2, sinf(theta) * 100 + self.bounds.size.height / 2);
        [self drawCircle:newCenter radius:5 endRadius:-M_PI_2 + (M_PI * 2) strokeColor:[UIColor greenColor] fillColor:[UIColor greenColor] withAnimation:NO];
    }

    [self drawCircle:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:100 endRadius:-M_PI_2 + (M_PI * 2) strokeColor:[UIColor brownColor] fillColor:[UIColor clearColor] withAnimation:YES];

    indexDay = currentDay;
    [self animatedLayer:endPogressLayer End:(CGFloat)currentDay/nbDay * 100];


}

- (void)drawCircle:(CGPoint)center radius:(CGFloat)radius endRadius:(CGFloat)endRadius strokeColor:(UIColor * )strokeColor fillColor:(UIColor * )fillColor withAnimation:(BOOL)animated {

    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:center
                                                         radius:radius
                                                     startAngle:-M_PI_2
                                                       endAngle:endRadius                                                      clockwise:YES];

    progressLayer = [[CAShapeLayer alloc] init];
    [progressLayer setPath:aPath.CGPath];
    [progressLayer setStrokeColor:strokeColor.CGColor];
    [progressLayer setFillColor:fillColor.CGColor];
    [progressLayer setLineWidth:3.f];
    [progressLayer setStrokeStart:0/100];
    if (animated) {
        [progressLayer setStrokeEnd:0/100];
    } else {
        [progressLayer setStrokeEnd:100/100];
    }
    [self.layer addSublayer:progressLayer];
}

-(void)swipeLeft:(UISwipeGestureRecognizer *)recognizer {
    if (indexDay < nbDay) {
        indexDay++;
        [self animatedLayer:endPogressLayer End:(CGFloat)indexDay/nbDay * 100];
    }

}

-(void)swipeRight:(UISwipeGestureRecognizer *)recognizer {
    if (indexDay != 0) {
        indexDay--;
        [self animatedLayer:endPogressLayer End:(CGFloat)indexDay/nbDay * 100];
    }
}

- (void)animatedLayer:(CGFloat)begin End:(CGFloat)end {
    endPogressLayer = end;
    [CATransaction begin];
    CABasicAnimation *animateStrokeDown = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [animateStrokeDown setFromValue:[NSNumber numberWithFloat:begin/100.]];
    [animateStrokeDown setToValue:[NSNumber numberWithFloat:end/100.]];
    [animateStrokeDown setDuration:0.5];
    [animateStrokeDown setFillMode:kCAFillModeForwards];
    [animateStrokeDown setRemovedOnCompletion:NO];
    [progressLayer addAnimation:animateStrokeDown forKey:@"strokeEnd"];
    [CATransaction commit];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return YES;
}


@end
