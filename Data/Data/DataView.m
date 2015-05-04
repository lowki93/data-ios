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

    self.arrayData = [[NSMutableArray alloc] init];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:baseView];

    heightContentView = self.bounds.size.height;
    centerCircle = CGPointMake(self.bounds.size.width/2, heightContentView/2);
//    radiusFirstCicle = (self.bounds.size.width * 0.046875) / 2;
//    radiusPhotoCicle = (self.bounds.size.width * 0.203125) / 2;
//    radiusGeolocCircle = (self.bounds.size.width * 0.484375) / 2;
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
    [self drawCircle:centerCircle radius:radiusData startAngle:80 strokeColor:baseView.blue fillColor:[UIColor clearColor] dotted:YES];
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

//        int nbSynchro = i;
        Data *currentData = currentDay.data[i];
//        /** for photos **/
//        [self updatePhotoData:currentData Synchro:nbSynchro];
//        /** for geoloc **/
//        [self updateGeolocData:currentData Synchro:nbSynchro];

        NSMutableDictionary *dataDictionnary = [[NSMutableDictionary alloc] init];
        [dataDictionnary setObject:[NSNumber numberWithInt:(int)[currentData.photos count]] forKey:@"photo"];
        [dataDictionnary setObject:[NSNumber numberWithInt:(int)[currentData.atmosphere count]] forKey:@"geoloc"];
        [dataDictionnary setObject:currentData.deplacement[@"stepNumber"] forKey:@"numberStep"];

        [self.arrayData addObject:dataDictionnary];

        [self createButton:i];
    }

}

- (void)createButton:(int)index {

    float radiusButton = 20;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTag:index];
    [button addTarget:self action:@selector(getInfoData:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat theta = (M_PI * 15 / 180 * index) - M_PI_2;
    CGPoint newCenter = CGPointMake(self.bounds.size.width / 2 + cosf(theta) * radiusData, sinf(theta) * radiusData + heightContentView/2);
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
