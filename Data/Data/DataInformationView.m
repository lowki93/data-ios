//
//  DataInformationView.m
//  Data
//
//  Created by kevin Budain on 04/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "DataInformationView.h"

@implementation DataInformationView

BaseViewController *baseView;
int size = 20;

- (void)init:(float)size {

    self.translation = 20;
    self.duration = 0.5;

    baseView = [[BaseViewController alloc] init];
    [baseView initView:baseView];

    UIFont *descriptionLabelFont = [UIFont fontWithName:@"MaisonNeue-Book" size:20];
    UIColor *descriptionColor = [baseView colorWithRGB:39 :37 :37 :1];

    UIFont *titleLabelFont = [UIFont fontWithName:@"MaisonNeue-Book" size:12];
    UIColor *titleColor = [baseView colorWithRGB:157 :157 :156 :1];

    self.geolocInformationLabel = [[UILabel alloc] init];
    [self.geolocInformationLabel setText:@"25"];
    [self.geolocInformationLabel setTextColor:descriptionColor];
    [self.geolocInformationLabel setFont:descriptionLabelFont];
    [self.geolocInformationLabel sizeToFit];
    [self.geolocInformationLabel setFrame:CGRectMake(0,
                                                     self.bounds.size.height / 6,
                                                     self.bounds.size.width,
                                                     20)];
    [self.geolocInformationLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.geolocInformationLabel];

    UILabel *geolocLabel = [[UILabel alloc] init];
    [geolocLabel setText:@"GEOLOCATIONS"];
    [geolocLabel setFont:titleLabelFont];
    [geolocLabel setTextColor:titleColor];
    [geolocLabel sizeToFit];
    [geolocLabel setFrame:CGRectMake(0,
                                     self.bounds.size.height / 4,
                                     self.bounds.size.width,
                                     geolocLabel.bounds.size.height)];
    [geolocLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:geolocLabel];

    self.pedometerInformationLabel = [[UILabel alloc] init];
    [self.pedometerInformationLabel setText:@"2.2 km"];
    [self.pedometerInformationLabel setTextColor:descriptionColor];
    [self.pedometerInformationLabel setFont:descriptionLabelFont];
    [self.pedometerInformationLabel sizeToFit];
    [self.pedometerInformationLabel setFrame:CGRectMake(0,
                                                        self.bounds.size.height / 2 - self.pedometerInformationLabel.bounds.size.height,
                                                        self.bounds.size.width,
                                                        20)];
    [self.pedometerInformationLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.pedometerInformationLabel];

    UILabel *pedometerLabel = [[UILabel alloc] init];
    [pedometerLabel setText:@"DISTANCE"];
    [pedometerLabel setFont:titleLabelFont];
    [pedometerLabel setTextColor:titleColor];
    [pedometerLabel sizeToFit];
    [pedometerLabel setFrame:CGRectMake(0,
                                        self.bounds.size.height / 2,
                                        self.bounds.size.width,
                                        20)];
    [pedometerLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:pedometerLabel];

    self.photoInformationLabel = [[UILabel alloc] init];
    [self.photoInformationLabel setText:@"10"];
    [self.photoInformationLabel setFont:descriptionLabelFont];
    [self.photoInformationLabel setTextColor:descriptionColor];
    [self.photoInformationLabel sizeToFit];
    [self.photoInformationLabel setFrame:CGRectMake(0,
                                                    self.bounds.size.height / 6 * 4,
                                                    self.bounds.size.width,
                                                    20)];
    [self.photoInformationLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.photoInformationLabel];

    UILabel *photoLabel = [[UILabel alloc] init];
    [photoLabel setText:@"PHOTOS"];
    [photoLabel setFont:titleLabelFont];
    [photoLabel setTextColor:titleColor];
    [photoLabel sizeToFit];
    [photoLabel setFrame:CGRectMake(0,
                                    self.bounds.size.height / 6 * 4 + 20,
                                    self.bounds.size.width,
                                    20)];
    [photoLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:photoLabel];

    [self animatedAllLabel:0 Translation:self.translation Alpha:0];

}

- (void)animatedAllLabel:(float)duration Translation:(int)translation Alpha:(int)alpha {

    for (UIView *view in self.subviews) {

        if([view isKindOfClass:[UILabel class]]) {

            UILabel *label = (UILabel *)view;

            [UIView animateWithDuration:duration delay:0 options:0 animations:^{

                label.transform = CGAffineTransformMakeTranslation(0, translation);
                label.alpha = alpha;

            } completion:nil];
            

        }

    }

}

@end
