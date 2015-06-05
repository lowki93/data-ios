//
//  TimeLineView.m
//  Data
//
//  Created by kevin Budain on 16/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "TimeLineView.h"
#import "BaseViewController.h"

@implementation TimeLineView

BaseViewController *baseView;

CGFloat endPogressLayer = 0;
float radius, ratioCenter;

- (void)initTimeLine:(int)nbDay indexDay:(int)indexDay {

    self.nbDay = nbDay;
    self.indexDay = indexDay;
    ratioCenter = 0.575;

    baseView = [[BaseViewController alloc] init];
    [baseView initView:baseView];

}

- (void)drawRect:(CGRect)rect {
    
    radius = (self.bounds.size.width /2 ) - 45;

    for (int i = 0; i < self.nbDay; i++) {
        CGFloat theta = ((M_PI * (360.0 / self.nbDay) * i)/ 180) - M_PI_2 + (M_PI_4 * 0 );
        CGPoint startPoint = CGPointMake(cosf(theta) * radius + self.bounds.size.width / 2,
                                         sinf(theta) * radius + self.bounds.size.height * ratioCenter);
        CGPoint endPoint = CGPointMake(cosf(theta) * (radius + 15) + self.bounds.size.width / 2,
                                       sinf(theta) * (radius + 15) + self.bounds.size.height * ratioCenter);

        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
        [path addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];

        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        [shapeLayer setPath:path.CGPath];
        [shapeLayer setStrokeColor:baseView.blackTimeLineColor.CGColor];
        [shapeLayer setLineWidth:4.0];

        [self.layer addSublayer:shapeLayer];

    }


    [self drawCircle:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height * ratioCenter)
              radius:radius - 20
           endRadius:-M_PI_2 + (M_PI * 2)
         strokeColor:baseView.greyTimeLineColor
           fillColor:[UIColor clearColor]
       withAnimation:YES];

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

- (void)animatedTimeLine:(int)indexDay {

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
