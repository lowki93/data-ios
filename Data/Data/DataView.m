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
CGFloat radiusData, radiusFirstCicle, radiusPhotoCicle, radiusGeolocCircle, radiusCaptaCircle, radiusPedometerCircle;

- (void)initView {

    for (CALayer *subLayer in self.layer.sublayers)
    {
        [subLayer removeFromSuperlayer];
    }

    self.arrayData = [[NSMutableArray alloc] init];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:baseView];

//    self.contentData = [[UIView alloc] init];
//    [self updateDataContent:CGRectNull Float:1.2];
//    [self.contentData setBackgroundColor:[UIColor yellowColor]];
//
//    [self addSubview:self.contentData];

    heightContentView = self.bounds.size.height;
    centerCircle = CGPointMake(self.bounds.size.width/2, heightContentView/2);
//    radiusFirstCicle = (self.bounds.size.width * 0.046875) / 2;
//    radiusPhotoCicle = (self.bounds.size.width * 0.203125) / 2;
    radiusGeolocCircle = (self.bounds.size.width * 0.484375) / 2;
//    radiusCaptaCircle = (self.bounds.size.width * 0.6484375) / 2;
//    radiusPedometerCircle = (self.bounds.size.width * 0.8125) / 2;
    radiusData = (self.bounds.size.width * 0.8125) / 2;

    float informationViewWidth = (radiusData - 20) * 2;
    self.informationView = [[DataInformationView alloc] init];
    [self.informationView setFrame:CGRectMake((self.bounds.size.width / 2) - (informationViewWidth / 2),
                               (self.bounds.size.height / 2) - (informationViewWidth / 2),
                               informationViewWidth,
                               informationViewWidth)];
    [self.informationView.layer setCornerRadius:informationViewWidth/2.];
    [self.informationView.layer setMasksToBounds:YES];
    [self.informationView setBackgroundColor:[UIColor whiteColor]];
    [self.informationView init:informationViewWidth];

    [self addSubview:self.informationView];

    [self.informationView setHidden:YES];

    [self createCircle];

}

- (void)createCircle {


//    [self drawCircle:centerCircle radius:radiusFirstCicle startAngle:0 strokeColor:baseView.lightBlue fillColor:[UIColor clearColor] dotted:NO];
//    [self drawCircle:centerCircle radius:radiusPhotoCicle startAngle:20 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:YES];
//    [self drawCircle:centerCircle radius:radiusGeolocCircle startAngle:40 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:NO];
//    [self drawCircle:centerCircle radius:radiusCaptaCircle startAngle:60 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:NO];
//    [self drawCircle:centerCircle radius:radiusData startAngle:80 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:YES];
}

- (void)drawCircle:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle strokeColor:(UIColor * )strokeColor fillColor:(UIColor * )fillColor dotted:(BOOL)dotted {

    CGFloat angle = ((M_PI * startAngle)/ 180);

    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:center
                                                         radius:radius
                                                     startAngle:angle
                                                       endAngle:2 * M_PI + angle
                                                      clockwise:YES];

    CAShapeLayer *gradientMask = [[CAShapeLayer alloc] init];
    [gradientMask setPath:aPath.CGPath];
    [gradientMask setStrokeColor:strokeColor.CGColor];
    [gradientMask setFillColor:fillColor.CGColor];
    [gradientMask setLineWidth:1.f];
    [gradientMask setStrokeStart:0/100];
    [gradientMask setStrokeEnd:100/100];

    if(dotted) {

        [gradientMask setLineJoin:kCALineJoinRound];
        [gradientMask setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],nil]];

    }
//
//    [self.layer addSublayer:gradientMask];

//    CAShapeLayer *gradientMask = [CAShapeLayer layer];
//    gradientMask.fillColor = [[UIColor clearColor] CGColor];
//    gradientMask.strokeColor = [[UIColor blackColor] CGColor];
//    gradientMask.lineWidth = 4;
//    gradientMask.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);

    //    CGMutablePathRef t = CGPathCreateMutable();
    //    CGPathMoveToPoint(t, NULL, 0, 0);
    //    CGPathAddLineToPoint(t, NULL, self.bounds.size.width, self.bounds.size.height);

//    gradientMask.path = aPath.CGPath;


    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0.5,1.0);
    gradientLayer.endPoint = CGPointMake(0.5,0.0);
    gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);

    NSMutableArray *colors = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [colors addObject:(id)[[UIColor colorWithHue:(0.1 * i) saturation:1 brightness:.8 alpha:1] CGColor]];
    }
    gradientLayer.colors = colors;

    [gradientLayer setMask:gradientMask];
    [self.layer addSublayer:gradientLayer];


}

- (void)drawData:(int)indexDay {

    Day *currentDay = [ApiController sharedInstance].experience.day[indexDay];

    for (int i = 0; i < [currentDay.data count]; i++) {
//    for (int i = 0; i < 25; i++) {

//        int nbSynchro = i;
        Data *currentData = currentDay.data[i];
//        /** for photos **/
//        [self updatePhotoData:currentData Synchro:nbSynchro];
//        /** for geoloc **/
//        [self updateGeolocData:currentData Synchro:nbSynchro];

//        NSMutableDictionary *dataDictionnary = [[NSMutableDictionary alloc] init];
//        [dataDictionnary setObject:[NSNumber numberWithInt:(int)[currentData.photos count]] forKey:@"photo"];
//        [dataDictionnary setObject:[NSNumber numberWithInt:(int)[currentData.atmosphere count]] forKey:@"geoloc"];
//        [dataDictionnary setObject:currentData.deplacement[@"stepNumber"] forKey:@"numberStep"];
//
//        [self.arrayData addObject:dataDictionnary];

        [self createButton:i];
    }

}

- (void)createButton:(int)index {

    float radiusButton = 20;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTag:index];
    [button addTarget:self action:@selector(getInfoData:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat theta = (M_PI * 15 / 180 * index) - M_PI_2;
    CGPoint newCenter = CGPointMake(self.bounds.size.width / 2 + cosf(theta) * radiusData, sinf(theta) * radiusData + self.bounds.size.height/2);
    [button setFrame:CGRectMake(newCenter.x - radiusButton/ 2, newCenter.y - radiusButton / 2, radiusButton, radiusButton)];
    [button setClipsToBounds:YES];
    [button setBackgroundColor:[UIColor redColor]];
    [button.layer setCornerRadius:radiusButton/2.f];

    [self addSubview:button];

}

- (IBAction)getInfoData:(id)sender {

    [self.informationView setHidden:NO];
    [self removeBorderButton];

    UIButton *button = (UIButton *)sender;
    [button.layer setBorderColor:[UIColor greenColor].CGColor];
    [button.layer setBorderWidth:2.f];

    int nbTag = (int)[button tag];
    NSDictionary *dictionnary = [self.arrayData objectAtIndex:nbTag];
    [self.informationView.photoInformationLabel setText:[NSString stringWithFormat:@"%@",dictionnary[@"photo"]]];
    [self.informationView.pedometerInformationLabel setText:[NSString stringWithFormat:@"%@ step",dictionnary[@"numberStep"]]];
    [self.informationView.geolocInformationLabel setText:[NSString stringWithFormat:@"%@",dictionnary[@"geoloc"]]];

}

- (void)removeBorderButton {

    for (UIView *subview in [self subviews]) {

        if([subview isKindOfClass:[UIButton class]]) {

            UIButton *button = (UIButton *)subview;
            [button.layer setBorderColor:[UIColor clearColor].CGColor];
            [button.layer setBorderWidth:0.f];
            
        }
    }

}

- (void)updateDataContent:(CGRect)frame Float:(float)scale {

    NSLog(@"%f, %f", self.bounds.size.width, scale);
    if( CGRectIsEmpty(frame) ) {
        frame = CGRectMake(-((self.bounds.size.width * scale / 2 ) - ( self.bounds.size.width / 2)),
                   -((self.bounds.size.height * scale /2 ) - (self.bounds.size.height / 2)),
                   self.bounds.size.width * scale,
                   self.bounds.size.height * scale);
    } else {
        frame = CGRectMake(-((frame.size.width * scale / 2 ) - ( frame.size.width / 2)),
                           -((frame.size.height * scale /2 ) - (frame.size.height / 2)),
                           frame.size.width * scale,
                           frame.size.height * scale);
    }

    [self.contentData setFrame:CGRectMake(-((self.bounds.size.width * scale / 2 ) - ( self.bounds.size.width / 2)),
                                          -((self.bounds.size.height * scale /2 ) - (self.bounds.size.height / 2)),
                                          self.bounds.size.width * scale,
                                          self.bounds.size.height * scale)];
    [self.contentData setBackgroundColor:[UIColor yellowColor]];


}

//- (void)updatePhotoData:(Data *)data Synchro:(NSInteger)nbSynchro {
//
//    for (int i = 0; i < [data.photos count]; i++) {
//
//        [self drawCirclePhoto:nbSynchro];
//
//    }
//
//}

//- (void)drawCirclePhoto:(NSInteger)nbSynchro {
//
//    int lowerAlpha = 1;
//    int upperAlpha = 7;
//    float randomAlpha = (lowerAlpha + arc4random() % (upperAlpha - lowerAlpha)) / 10. ;
//    int randomAngle = arc4random() % 45;
//    CGFloat theta = ((M_PI * randomAngle)/ 180) - M_PI_2 + (M_PI_4 * nbSynchro );
//    CGPoint newCenter = CGPointMake(self.bounds.size.width/2 + cosf(theta) * radiusPhotoCicle, sinf(theta) * radiusPhotoCicle + heightContentView/2);
//    [self drawCircle:newCenter radius:10 startAngle:0 strokeColor:[UIColor clearColor] fillColor:[baseView.circlePhotoColor colorWithAlphaComponent:randomAlpha] dotted:NO];
//
//}

//- (void)updateGeolocData:(Data *)data Synchro:(NSInteger)nbSynchro {
//
//    for (int i = 0; i < [data.atmosphere count]; i++) {
//
//        [self drawCircleGeoloc:nbSynchro];
//
//    }
//
//}

//- (void)drawCircleGeoloc:(NSInteger)nbSynchro {
//    
//    /* random alpha */
//    int lowerAlpha = 1;
//    int upperAlpha = 7;
//    float randomAlpha = (lowerAlpha + arc4random() % (upperAlpha - lowerAlpha)) / 10. ;
//    /* random angle */
//    int randomAngle = arc4random() % 45;
//    /* random radius */
//    int lowerRadius = radiusGeolocCircle - 20;
//    int upperRadius = radiusGeolocCircle + 20;
//    int randomRadius = lowerRadius + arc4random() % (upperRadius - lowerRadius);
//    /* random radius */
//    int lowerCircleRadius = 5;
//    int upperCircleRadius = 20;
//    int randomCircleRadius = lowerCircleRadius + arc4random() % (upperCircleRadius - lowerCircleRadius);
//    CGFloat theta = ((M_PI * randomAngle)/ 180) - M_PI_2 + (M_PI_4 * nbSynchro );
//    CGPoint newCenter = CGPointMake(self.bounds.size.width/2 + cosf(theta) * randomRadius, sinf(theta) * randomRadius + heightContentView/2);
//
//    [self drawCircle:newCenter radius:randomCircleRadius startAngle:0 strokeColor:[UIColor clearColor] fillColor:[baseView.circlegeolocColor colorWithAlphaComponent:randomAlpha] dotted:NO];
//
//}


@end
