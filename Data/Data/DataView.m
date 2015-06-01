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
UIViewController *dataViewController;

float heightContentView, scale, beginTimeLayer;
CGPoint centerCircle;
CGFloat radiusData, radiusGeolocCircle, radiusCaptaCircle, radiusPedometerCircle;

- (void)initView:(UIViewController *)viewController {

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

    scale = 1.5;
    heightContentView = self.bounds.size.height;
    centerCircle = CGPointMake(self.bounds.size.width/2, heightContentView/2);
    radiusGeolocCircle = (self.bounds.size.width * 0.484375) / 2;
    radiusData = (self.bounds.size.width * 0.8125) / 2;

    /** captionImage **/
    self.captionImageView = [[UIImageView alloc] init];
    [self.captionImageView setFrame:CGRectMake((self.bounds.size.width / 2) - radiusData,
                                               (self.bounds.size.height / 2) - radiusData,
                                               radiusData * 2,
                                               radiusData * 2 )];
    [self addSubview:self.captionImageView];

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

    if (!self.informationButton) {

        beginTimeLayer = 0;
        for (int i = 0; i < 24; i++) {

            [self writeCircle:i];
            
        }

    }

}

- (void)writeCircle:(int)index {

    CGFloat theta = (M_PI * 15 / 180 * index) - M_PI_2;
    CGPoint newCenter = CGPointMake(self.bounds.size.width / 2 + cosf(theta) * radiusData, sinf(theta) * radiusData + self.bounds.size.height/2);

    UIColor *color  = [baseView colorWithRGB:37 :37 :112 :1];
    int radius = 3;

    if (index == 18) {
        color = [baseView colorWithRGB:210 :70 :41 :1];
        radius = 5;
    }

    [self drawCircle:newCenter radius:radius startAngle:-M_PI_2 + (M_PI * 2) strokeColor:color fillColor:color dotted:NO];

}

- (void)writeSelecteButtonView:(int)index {


    CGFloat theta = (M_PI * 15 / 180 * index) - M_PI_2;
    CGPoint newCenter = CGPointMake(self.bounds.size.width / 2 + cosf(theta) * radiusData, sinf(theta) * radiusData + self.bounds.size.height/2);

    int width = 54;
    self.selectedButtonImageView = [[UIImageView alloc] init];
    [self.selectedButtonImageView setFrame:CGRectMake(newCenter.x - (width / 2), newCenter.y - (width / 2), width, width)];
    [self.selectedButtonImageView setAlpha:0];
    [self addSubview: self.selectedButtonImageView];

    [NSThread detachNewThreadSelector:@selector(generateClickAnimationImage) toTarget:self withObject:nil];

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

    [self.layer addSublayer:gradientMask];

    beginTimeLayer += 0.07;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setBeginTime: CACurrentMediaTime() + beginTimeLayer];
    [animation setDuration: 0.3];
    [animation setFromValue: [NSNumber numberWithFloat:0.0f]];
    [animation setToValue: [NSNumber numberWithFloat:1.0f]];
    [animation setRemovedOnCompletion: NO];
    [animation setFillMode: kCAFillModeBoth];
    [animation setAdditive: NO];
    [gradientMask addAnimation:animation forKey:@"opacityIN"];

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

    float distance = 0.f;
    for(int i = 0; i < [currentData.atmosphere count]; i ++) {

       distance += (float)[currentData.atmosphere[i][@"distance"] floatValue] / 1000;

    }

    [dataDictionnary setObject:[NSString stringWithFormat:@"%.2f", distance] forKey:@"distance"];

    int totalData = (int)[currentData.photos count] + (int)[currentData.atmosphere count];
    float radiusButton;

    if (totalData < 1)
        radiusButton = 5;
    else if (totalData <= 2)
        radiusButton = 10;
    else if (totalData <= 3)
        radiusButton = 15;
    else if (totalData <= 4)
        radiusButton = 20;
    else if (totalData <= 5)
        radiusButton = 25;
    else if (totalData >= 6)
        radiusButton = 25;

    self.nbPhoto += (int)[currentData.photos count];
    self.nbGeoloc += (int)[currentData.atmosphere count];
    self.distance += distance;

    [self.arrayData addObject:dataDictionnary];

    [self createButton:index Radius:radiusButton];

}

- (void)createButton:(int)index Radius:(float)radius {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTag:index];

    if(self.informationButton) {
        [button addTarget:self action:@selector(getInfoData:) forControlEvents:UIControlEventTouchUpInside];
    }

    CGFloat theta = (M_PI * 15 / 180 * index) - M_PI_2;
    CGPoint newCenter = CGPointMake(self.bounds.size.width / 2 + cosf(theta) * radiusData, sinf(theta) * radiusData + self.bounds.size.height/2);
    [button setFrame:CGRectMake(newCenter.x - radius/ 2, newCenter.y - radius / 2, radius, radius)];
    [button setClipsToBounds:YES];

    [button setBackgroundColor:[baseView.colorMuchActivityArray objectAtIndex:index / 4]];
    [button.layer setCornerRadius:radius/2.f];
    [button setAlpha:0];

    [self addSubview:button];

    [UIView animateWithDuration:0.3 delay:self.delay options:0 animations:^{

        [button setAlpha:1];

    } completion:nil];

    self.delay += 0.07;
}

- (void)generateDataAfterSynchro:(Day *)currentDay {

    [self generateData:(int)([currentDay.data count] - 1) Day:currentDay];
    [self updateAllInformation];

}

- (IBAction)getInfoData:(id)sender {

    if (self.selectedButtonImageView) {
        [self removeButtonSelector];
    }

    if (!self.informationViewActive) {

        self.informationViewActive = YES;
        [UIView animateWithDuration:0.5 delay:0.2 options:0 animations:^{

            [self.informationView setTransform:CGAffineTransformIdentity];
            [self.informationView setAlpha:1];

        } completion:nil];

    }

    if([dataViewController isKindOfClass:[DataViewController class]]) {
        DataViewController *currentViewController = (DataViewController *)dataViewController;
        [currentViewController.view removeGestureRecognizer:currentViewController.informationDataGesture];
        [currentViewController.view addGestureRecognizer:currentViewController.closeInformationGesture];
    }


    if([dataViewController isKindOfClass:[TutorialViewController class]]) {
        TutorialViewController *currentViewController = (TutorialViewController *)dataViewController;
        [currentViewController.view removeGestureRecognizer:currentViewController.informationDataGesture];
        [currentViewController.view addGestureRecognizer:currentViewController.closeInformationGesture];
    }

    [self removeBorderButton];

    UIButton *button = (UIButton *)sender;
    [button.layer setBorderColor:[UIColor greenColor].CGColor];
    [button.layer setBorderWidth:2.f];

    [self animatedCaptionImageView:0];
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

- (void)activeCapta {

     [NSThread detachNewThreadSelector:@selector(generateCaptionLoaderAnimationImage) toTarget:self withObject:nil];

}

- (void)generateCaptionLoaderAnimationImage {

    @autoreleasepool {

        NSMutableArray *imageArray = [[NSMutableArray alloc] init];

        for( int index = 0; index < 79; index++ ){

            NSString *imageName = [NSString stringWithFormat:@"captation_%i.png", index];
            [imageArray addObject:[UIImage imageNamed:imageName]];

        };

        [self.captionImageView setAnimationImages:imageArray];
        [self.captionImageView setAnimationDuration:4];
        [self.captionImageView setAnimationRepeatCount:0];

        [self performSelectorOnMainThread:@selector(addTutorialAnimationImage) withObject:NULL waitUntilDone:NO];

    }

}

- (void)addTutorialAnimationImage {

    [self addSubview:self.captionImageView];
    [self.captionImageView startAnimating];
    
}

- (void)generateClickAnimationImage {

    @autoreleasepool {

        NSMutableArray *imageArray = [[NSMutableArray alloc] init];

        for( int index = 0; index < 38; index++ ){

            NSString *imageName = [NSString stringWithFormat:@"clic_0_%i.png", index];
            [imageArray addObject:[UIImage imageNamed:imageName]];

        };

        [self.selectedButtonImageView setAnimationImages:imageArray];
        [self.selectedButtonImageView setAnimationDuration:2];
        [self.selectedButtonImageView setAnimationRepeatCount:0];

        [self performSelectorOnMainThread:@selector(addClickAnimationImage) withObject:NULL waitUntilDone:NO];

    }

}

- (void)addClickAnimationImage {

    [self addSubview:self.selectedButtonImageView];

    [UIView animateWithDuration:self.informationView.duration  delay:0  options:0 animations:^{

        [self.selectedButtonImageView setAlpha:1];

    } completion:nil];
    [self.selectedButtonImageView startAnimating];
    [self performSelector:@selector(removeButtonSelector) withObject:nil afterDelay:3.5];
    
}

- (void)removeCapta {

    [UIView animateWithDuration:self.informationView.duration animations:^{

        [self.captionImageView setAlpha:0];

    } completion:^(BOOL finished) {

        [self.captionImageView setHidden:YES];

    }];

}

- (void)animatedCaptionImageView:(float)alpha {

    [UIView animateWithDuration:self.informationView.duration delay:0 options:0 animations:^{

        [self.captionImageView setAlpha:alpha];

    } completion:nil];


}


- (void)addActionForButton {

    for (UIView *subview in [self subviews]) {

        if([subview isKindOfClass:[UIButton class]]) {

            UIButton *button = (UIButton *)subview;
            [button addTarget:self action:@selector(getInfoData:) forControlEvents:UIControlEventTouchUpInside];

        }
    }

}

- (void)removeActionForButton {

    for (UIView *subview in [self subviews]) {

        if([subview isKindOfClass:[UIButton class]]) {

            UIButton *button = (UIButton *)subview;
            [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            
        }
    }
    
}

- (void)removeButtonSelector {

    [UIView animateWithDuration:self.informationView.duration  delay:self.informationView.duration-0.2  options:0 animations:^{

        [self.selectedButtonImageView setAlpha:0];

    } completion:^(BOOL finished){

        int width = 100;
        [self.selectedButtonImageView setFrame:CGRectMake((self.bounds.size.width / 2) - (width / 2),
                                                     (self.bounds.size.height / 2) - (width / 2),
                                                     width,
                                                     width)];

    }];

}


@end
