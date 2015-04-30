//
//  TimeLineView.m
//  Data
//
//  Created by kevin Budain on 16/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "TimeLineView.h"

@implementation TimeLineView

CGFloat endPogressLayer = 0;
float radius;

- (void)initTimeLine:(int)nbDay indexDay:(int)indexDay {

    self.nbDay = nbDay;
    self.indexDay = indexDay;

}

- (void)drawRect:(CGRect)rect {

    radius = (self.bounds.size.width /2 ) - 20;

    for (int i = 0; i < self.nbDay; i++) {
        CGFloat theta = ((M_PI * (360.0 / self.nbDay) * i)/ 180) - M_PI_2 + (M_PI_4 * 0 );
        CGPoint newCenter = CGPointMake(cosf(theta) * radius + self.bounds.size.width / 2, sinf(theta) * radius + self.bounds.size.height / 2);
        [self drawCircle:newCenter radius:5 endRadius:-M_PI_2 + (M_PI * 2) strokeColor:[UIColor greenColor] fillColor:[UIColor greenColor] withAnimation:NO];
    }

    [self drawCircle:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:radius endRadius:-M_PI_2 + (M_PI * 2) strokeColor:[UIColor yellowColor] fillColor:[UIColor clearColor] withAnimation:YES];

    [self animatedLayer:endPogressLayer End:(CGFloat)self.indexDay/self.nbDay * 100];


}

- (void)drawCircle:(CGPoint)center radius:(CGFloat)radius endRadius:(CGFloat)endRadius strokeColor:(UIColor * )strokeColor fillColor:(UIColor * )fillColor withAnimation:(BOOL)animated {

    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:center
                                                         radius:radius
                                                     startAngle:-M_PI_2
                                                       endAngle:endRadius                                                      clockwise:YES];

    self.progressLayer = [[CAShapeLayer alloc] init];
    [self.progressLayer setPath:aPath.CGPath];
    [self.progressLayer setStrokeColor:strokeColor.CGColor];
    [self.progressLayer setFillColor:fillColor.CGColor];
    [self.progressLayer setLineWidth:3.f];
    [self.progressLayer setStrokeStart:0/100];
    if (animated) {
        [self.progressLayer setStrokeEnd:0/100];
    } else {
        [self.progressLayer setStrokeEnd:100/100];
    }
    [self.layer addSublayer:self.progressLayer];
}

- (void)animatedTimeLine:(int)indexDay; {

    [self animatedLayer:endPogressLayer End:(CGFloat)indexDay/self.nbDay * 100];

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
    [self.progressLayer addAnimation:animateStrokeDown forKey:@"strokeEnd"];
    [CATransaction commit];

}

@end
