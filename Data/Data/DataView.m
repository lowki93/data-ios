//
//  DataView.m
//  Data
//
//  Created by kevin Budain on 30/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "DataView.h"
#import "Day.h"
#import "Data.h"

@implementation DataView

BaseViewController *baseView;

float heightContentView;
CGPoint centerCircle;
CGFloat radiusFirstCicle, radiusPhotoCicle, radiusGeolocCircle, radiusCaptaCircle, radiusPedometerCircle;

- (void)initView {

    baseView = [[BaseViewController alloc] init];
    [baseView initView:baseView];

    heightContentView = self.bounds.size.height;
    [self createCircle];

}

- (void)createCircle {

    centerCircle = CGPointMake(self.bounds.size.width/2, heightContentView/2);
    radiusFirstCicle = (self.bounds.size.width * 0.046875) / 2;
    radiusPhotoCicle = (self.bounds.size.width * 0.203125) / 2;
    radiusGeolocCircle = (self.bounds.size.width * 0.484375) / 2;
    radiusCaptaCircle = (self.bounds.size.width * 0.6484375) / 2;
    radiusPedometerCircle = (self.bounds.size.width * 0.8125) / 2;

    [self drawCircle:centerCircle radius:radiusFirstCicle startAngle:0 strokeColor:baseView.lightBlue fillColor:[UIColor clearColor] dotted:NO];
    [self drawCircle:centerCircle radius:radiusPhotoCicle startAngle:20 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:YES];
    [self drawCircle:centerCircle radius:radiusGeolocCircle startAngle:40 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:NO];
    [self drawCircle:centerCircle radius:radiusCaptaCircle startAngle:60 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:NO];
    [self drawCircle:centerCircle radius:radiusPedometerCircle startAngle:80 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:YES];
}

- (void)drawCircle:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle strokeColor:(UIColor * )strokeColor fillColor:(UIColor * )fillColor dotted:(BOOL)dotted {

    CGFloat angle = ((M_PI * startAngle)/ 180);

    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:center
                                                         radius:radius
                                                     startAngle:angle
                                                       endAngle:2 * M_PI + angle
                                                      clockwise:YES];

    CAShapeLayer *progressLayer = [[CAShapeLayer alloc] init];
    [progressLayer setPath:aPath.CGPath];
    [progressLayer setStrokeColor:strokeColor.CGColor];
    [progressLayer setFillColor:fillColor.CGColor];
    [progressLayer setLineWidth:1.f];
    [progressLayer setStrokeStart:0/100];
    [progressLayer setStrokeEnd:100/100];
    if(dotted) {
        [progressLayer setLineJoin:kCALineJoinRound];
        [progressLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],nil]];
    }
    [self.layer addSublayer:progressLayer];

}

- (void)drawData:(int)indexDay {

    Day *currentDay = [ApiController sharedInstance].experience.day[indexDay];

    for (int i = 0; i < [currentDay.data count]; i++) {

        int nbSynchro = i;
        Data *currentData = currentDay.data[i];
        /** for photos **/
        [self updatePhotoData:currentData Synchro:nbSynchro];
        /** for geoloc **/
        [self updateGeolocData:currentData Synchro:nbSynchro];
        
    }

}

- (void)updatePhotoData:(Data *)data Synchro:(NSInteger)nbSynchro {

    for (int i = 0; i < [data.photos count]; i++) {

        [self drawCirclePhoto:nbSynchro];

    }

}

- (void)drawCirclePhoto:(NSInteger)nbSynchro {

    int lowerAlpha = 1;
    int upperAlpha = 7;
    float randomAlpha = (lowerAlpha + arc4random() % (upperAlpha - lowerAlpha)) / 10. ;
    int randomAngle = arc4random() % 45;
    CGFloat theta = ((M_PI * randomAngle)/ 180) - M_PI_2 + (M_PI_4 * nbSynchro );
    CGPoint newCenter = CGPointMake(self.bounds.size.width/2 + cosf(theta) * radiusPhotoCicle, sinf(theta) * radiusPhotoCicle + heightContentView/2);
    [self drawCircle:newCenter radius:10 startAngle:0 strokeColor:[UIColor clearColor] fillColor:[baseView.circlePhotoColor colorWithAlphaComponent:randomAlpha] dotted:NO];

}

- (void)updateGeolocData:(Data *)data Synchro:(NSInteger)nbSynchro {

    for (int i = 0; i < [data.atmosphere count]; i++) {

        [self drawCircleGeoloc:nbSynchro];

    }

}

- (void)drawCircleGeoloc:(NSInteger)nbSynchro {
    
    /* random alpha */
    int lowerAlpha = 1;
    int upperAlpha = 7;
    float randomAlpha = (lowerAlpha + arc4random() % (upperAlpha - lowerAlpha)) / 10. ;
    /* random angle */
    int randomAngle = arc4random() % 45;
    /* random radius */
    int lowerRadius = radiusGeolocCircle - 20;
    int upperRadius = radiusGeolocCircle + 20;
    int randomRadius = lowerRadius + arc4random() % (upperRadius - lowerRadius);
    /* random radius */
    int lowerCircleRadius = 5;
    int upperCircleRadius = 20;
    int randomCircleRadius = lowerCircleRadius + arc4random() % (upperCircleRadius - lowerCircleRadius);
    CGFloat theta = ((M_PI * randomAngle)/ 180) - M_PI_2 + (M_PI_4 * nbSynchro );
    CGPoint newCenter = CGPointMake(self.bounds.size.width/2 + cosf(theta) * randomRadius, sinf(theta) * randomRadius + heightContentView/2);

    [self drawCircle:newCenter radius:randomCircleRadius startAngle:0 strokeColor:[UIColor clearColor] fillColor:[baseView.circlegeolocColor colorWithAlphaComponent:randomAlpha] dotted:NO];

}


@end
