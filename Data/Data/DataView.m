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
DataViewController *dataViewController;

float heightContentView;
CGPoint centerCircle;
CGFloat radiusData, radiusFirstCicle, radiusPhotoCicle, radiusGeolocCircle, radiusCaptaCircle, radiusPedometerCircle;

- (void)initView:(DataViewController *)viewController {

    for (CALayer *subLayer in self.layer.sublayers)
    {
        [subLayer removeFromSuperlayer];
    }

    self.nbPhoto = 0;
    self.nbGeoloc = 0;
    self.distance = 0;
    self.delay = 1;

    self.arrayData = [[NSMutableArray alloc] init];

    dataViewController = viewController;

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

    /** label for hours **/
    UIFont *labelFont = [UIFont fontWithName:@"MaisonNeue-Book" size:15];
    UIColor *labelColor = [baseView colorWithRGB:157 :157 :156 :1];
    self.hoursLabel = [[UILabel alloc] init];
    [self.hoursLabel setFrame:CGRectMake(0, 20, self.bounds.size.width, 15)];
    [self.hoursLabel setText:@""];
    [self.hoursLabel setTextColor:labelColor];
    [self.hoursLabel setFont:labelFont];
    [self.hoursLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.hoursLabel];

    float informationViewWidth = (radiusData - 30) * 2;
    /** information by hours **/
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
    [self scaleInformationView:self.informationView];
    [self addSubview:self.informationView];

    /** information by Day **/
    self.allDataView = [[DataInformationView alloc] init];
    informationViewWidth = informationViewWidth + 10;
    [self.allDataView setFrame:CGRectMake((self.bounds.size.width / 2) - (informationViewWidth / 2),
                                              (self.bounds.size.height / 2) - (informationViewWidth / 2),
                                              informationViewWidth,
                                              informationViewWidth)];
    [self.allDataView.layer setCornerRadius:informationViewWidth/2.];
    [self.allDataView setBackgroundColor:[UIColor whiteColor]];
    [self.allDataView init:informationViewWidth];
    [self.allDataView.layer setMasksToBounds:YES];
    [self scaleInformationView:self.allDataView];
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
    [gradientLayer setStartPoint:CGPointMake(0.5, 1.0)];
    [gradientLayer setEndPoint:CGPointMake(0.5, 0.0)];
    [gradientLayer setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];

    NSMutableArray *colors = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [colors addObject:(id)[[UIColor colorWithHue:(0.1 * i) saturation:1 brightness:.8 alpha:1] CGColor]];
    }
    [gradientLayer setColors:colors];
    [gradientLayer setMask:gradientMask];

    [self.layer addSublayer:gradientLayer];

}

- (void)drawData:(int)indexDay {

    if(indexDay <= ([[ApiController sharedInstance].experience.day count] - 1)){

        Day *currentDay = [ApiController sharedInstance].experience.day[indexDay];

        for (int i = 0; i < [currentDay.data count]; i++) {

            [self generateData:i Day:currentDay];

        }

        self.delay = 0.5;

        [self updateAllInformation];

    }

}

- (void)generateData:(int)index Day:(Day *)day {

    Data *currentData = day.data[index];

    NSMutableDictionary *dataDictionnary = [[NSMutableDictionary alloc] init];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString: currentData.date];

    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"h:mm a"];
    NSString *dateString = [timeFormat stringFromDate:date];

    [dataDictionnary setObject:[NSString stringWithFormat:@"%@", dateString] forKey:@"date"];
    [dataDictionnary setObject:[NSNumber numberWithInt:(int)[currentData.photos count]] forKey:@"photo"];
    [dataDictionnary setObject:[NSNumber numberWithInt:(int)[currentData.atmosphere count]] forKey:@"geoloc"];

    float distance;
    for(int i = 0; i < [currentData.atmosphere count]; i ++) {

       distance += [currentData.atmosphere[i][@"distance"] floatValue] / 1000;

    }

    [dataDictionnary setObject:[NSString stringWithFormat:@"%.2f", distance] forKey:@"distance"];

    self.nbPhoto += (int)[currentData.photos count];
    self.nbGeoloc += (int)[currentData.atmosphere count];
    self.distance += distance   ;

    [self.arrayData addObject:dataDictionnary];

    [self createButton:index];

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
    [button setAlpha:0];

    [self addSubview:button];

    [UIView animateWithDuration:0.3 delay:self.delay options:0 animations:^{

        [button setAlpha:1];

    } completion:nil];

    self.delay += 0.1;
}

- (void)generateDataAfterSynchro:(Day *)currentDay {

    NSLog(@"draw");
    [self generateData:(int)([currentDay.data count] - 1) Day:currentDay];
    [self updateAllInformation];

}

- (IBAction)getInfoData:(id)sender {

    if (!self.informationViewActive) {

        self.informationViewActive = YES;
        [UIView animateWithDuration:0.5 delay:0.2 options:0 animations:^{

            [self.informationView setTransform:CGAffineTransformIdentity];
            [self.informationView setAlpha:1];

        } completion:nil];

    }

    [dataViewController.view removeGestureRecognizer:dataViewController.informationDataGesture];
    [dataViewController.view addGestureRecognizer:dataViewController.closeInformationGesture];
    [self removeBorderButton];

    UIButton *button = (UIButton *)sender;
    [button.layer setBorderColor:[UIColor greenColor].CGColor];
    [button.layer setBorderWidth:2.f];

    [self.informationView animatedAllLabel:self.informationView.duration Translation:self.informationView.translation Alpha:0];
    [UIView animateWithDuration:self.informationView.duration delay:0 options:0 animations:^{

        [self.hoursLabel setAlpha:0];

    } completion:^(BOOL finished){

        int nbTag = (int)[button tag];
        NSDictionary *dictionary = [self.arrayData objectAtIndex:nbTag];
        [self changeText:dictionary];

    }];

}

- (void)changeText:(NSDictionary *)dictionary {

    [self.hoursLabel setText:[NSString stringWithFormat:@"%@",dictionary[@"date"]]];
    [self.informationView.photoInformationLabel setText:[NSString stringWithFormat:@"%@",dictionary[@"photo"]]];
    [self.informationView.pedometerInformationLabel setText:[NSString stringWithFormat:@"%@ km",dictionary[@"distance"]]];
    [self.informationView.geolocInformationLabel setText:[NSString stringWithFormat:@"%@",dictionary[@"geoloc"]]];

    [self.informationView animatedAllLabel:self.informationView.duration Translation:0 Alpha:1];
    [UIView animateWithDuration:self.informationView.duration delay:0 options:0 animations:^{

        [self.hoursLabel setAlpha:1];

    } completion:nil];
    
}

- (void)updateAllInformation {

    [self.allDataView.photoInformationLabel setText:[NSString stringWithFormat:@"%i",self.nbPhoto]];
    [self.allDataView.pedometerInformationLabel setText:[NSString stringWithFormat:@"%.2f km",self.distance]];
    [self.allDataView.geolocInformationLabel setText:[NSString stringWithFormat:@"%i",self.nbGeoloc]];

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

- (void)scaleInformationView:(UIView *)view {

    CGAffineTransform informationViewtransform = view.transform;
    [view setTransform:CGAffineTransformScale(informationViewtransform, 0.1, 0.1)];
    [view setAlpha:0];

}

@end
