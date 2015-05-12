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
DataViewController *dataViewController2;

float heightContentView;
CGPoint centerCircle;
CGFloat radiusData, radiusFirstCicle, radiusPhotoCicle, radiusGeolocCircle, radiusCaptaCircle, radiusPedometerCircle;

- (void)initView:(DataViewController *)dataViewController {

    for (CALayer *subLayer in self.layer.sublayers)
    {
        [subLayer removeFromSuperlayer];
    }

    self.arrayData = [[NSMutableArray alloc] init];

     dataViewController2 = dataViewController;

    baseView = [[BaseViewController alloc] init];
    [baseView initView:baseView];

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
    self.informationViewActive = NO;
    [self scaleInformationView];
    [self addSubview:self.informationView];

    self.allDataView = [[AllDataView alloc] init];
    informationViewWidth = informationViewWidth + 10;
    [self.allDataView setFrame:CGRectMake((self.bounds.size.width / 2) - (informationViewWidth / 2),
                                              (self.bounds.size.height / 2) - (informationViewWidth / 2),
                                              informationViewWidth,
                                              informationViewWidth)];
    [self.allDataView.layer setCornerRadius:informationViewWidth/2.];
    [self.allDataView setBackgroundColor:[UIColor whiteColor]];
    [self.allDataView.layer setMasksToBounds:YES];
    [self.allDataView initView];

    CGAffineTransform transform = self.allDataView.transform;
    [self.allDataView setTransform:CGAffineTransformScale(transform, 0.1, 0.1)];
    [self.allDataView setAlpha:0];

    [self addSubview:self.allDataView];

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

    int nbPhoto = 0, nbGeoloc = 0;
    float distance = 0;

    for (int i = 0; i < [currentDay.data count]; i++) {
//    for (int i = 0; i < 25; i++) {

//        int nbSynchro = i;
        Data *currentData = currentDay.data[i];
//        /** for photos **/
//        [self updatePhotoData:currentData Synchro:nbSynchro];
//        /** for geoloc **/
//        [self updateGeolocData:currentData Synchro:nbSynchro];

        NSMutableDictionary *dataDictionnary = [[NSMutableDictionary alloc] init];
        [dataDictionnary setObject:[NSNumber numberWithInt:(int)[currentData.photos count]] forKey:@"photo"];
        [dataDictionnary setObject:[NSNumber numberWithInt:(int)[currentData.atmosphere count]] forKey:@"geoloc"];
        [dataDictionnary setObject:[NSString stringWithFormat:@"%.2f", [currentData.deplacement[@"distance"] floatValue] / 1000] forKey:@"distance"];

        nbPhoto += (int)[currentData.photos count];
        nbGeoloc += (int)[currentData.atmosphere count];
        distance += [currentData.deplacement[@"distance"] intValue] / 1000;

        [self.arrayData addObject:dataDictionnary];

        [self createButton:i];
    }

    [self.allDataView.photoInformationLabel setText:[NSString stringWithFormat:@"%i",nbPhoto]];
    [self.allDataView.pedometerInformationLabel setText:[NSString stringWithFormat:@"%.2f",distance]];
    [self.allDataView.geolocInformationLabel setText:[NSString stringWithFormat:@"%i",nbGeoloc]];

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

//    [self.informationView setHidden:NO];
    if (!self.informationViewActive) {

        self.informationViewActive = YES;
        [UIView animateWithDuration:0.5 delay:0.2 options:0 animations:^{

            [self.informationView setTransform:CGAffineTransformIdentity];
            [self.informationView setAlpha:1];

        } completion:^(BOOL finished){



        }];


    }


    [dataViewController2.view removeGestureRecognizer:dataViewController2.informationDataGesture];
    [dataViewController2.view addGestureRecognizer:dataViewController2.closeInformationGesture];
    [self removeBorderButton];

    UIButton *button = (UIButton *)sender;
    [button.layer setBorderColor:[UIColor greenColor].CGColor];
    [button.layer setBorderWidth:2.f];

    [self.informationView animatedAllLabel:self.informationView.duration Translation:self.informationView.translation Alpha:0];

    int nbTag = (int)[button tag];
    NSDictionary *dictionary = [self.arrayData objectAtIndex:nbTag];
    [self performSelector:@selector(changeText:) withObject:dictionary afterDelay:self.informationView.duration];

}

- (void)changeText:(NSDictionary *)dictionary {

    [self.informationView.photoInformationLabel setText:[NSString stringWithFormat:@"%@",dictionary[@"photo"]]];
    [self.informationView.pedometerInformationLabel setText:[NSString stringWithFormat:@"%@ km",dictionary[@"distance"]]];
    [self.informationView.geolocInformationLabel setText:[NSString stringWithFormat:@"%@",dictionary[@"geoloc"]]];

    [self.informationView animatedAllLabel:self.informationView.duration Translation:0 Alpha:1];
    
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

- (void)scaleInformationView {

    CGAffineTransform informationViewtransform = self.informationView.transform;
    [self.informationView setTransform:CGAffineTransformScale(informationViewtransform, 0.1, 0.1)];
    [self.informationView setAlpha:0];

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
