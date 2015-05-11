//
//  AllDataView.m
//  Data
//
//  Created by kevin Budain on 11/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "AllDataView.h"

@implementation AllDataView

BaseViewController *baseView;

- (void)initView {


    baseView = [[BaseViewController alloc] init];
    [baseView initView:baseView];

    UIFont *titleLabelFont = [UIFont fontWithName:@"MaisonNeue-Book" size:15];

    UILabel *todayLabel = [[UILabel alloc] init];
    [todayLabel setText:@"TODAY"];
    [todayLabel setFont:titleLabelFont];
    [todayLabel sizeToFit];
    [todayLabel setFrame:CGRectMake((self.bounds.size.width / 2 ) - (todayLabel.bounds.size.width / 2),
                                    self.bounds.size.height / 6,
                                    todayLabel.bounds.size.width,
                                    todayLabel.bounds.size.height)];
    [todayLabel setTextColor:[baseView colorWithRGB:29 :29 :27 :1]];
    [todayLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:todayLabel];

    UILabel *photoLabel = [[UILabel alloc] init];
    [photoLabel setText:@"photos"];
    [photoLabel setFont:titleLabelFont];
    [photoLabel sizeToFit];
    [photoLabel setFrame:CGRectMake((self.bounds.size.width / 2 ) - photoLabel.bounds.size.width - 5,
                                    self.bounds.size.height / 3,
                                    photoLabel.bounds.size.width,
                                    photoLabel.bounds.size.height)];
    [photoLabel setTextColor:[baseView colorWithRGB:29 :29 :27 :1]];
    [photoLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:photoLabel];

    self.photoInformationLabel = [[UILabel alloc] init];
    [self.photoInformationLabel setText:@"photos"];
    [self.photoInformationLabel setFont:titleLabelFont];
    [self.photoInformationLabel sizeToFit];
    [self.photoInformationLabel setFrame:CGRectMake((self.bounds.size.width / 2 ) + 5 /*+ (photoLabel.bounds.size.width / 2)*/,
                                                    self.bounds.size.height / 3,
                                                    photoLabel.bounds.size.width,
                                                    photoLabel.bounds.size.height)];
    [self.photoInformationLabel setTextColor:[baseView colorWithRGB:29 :29 :27 :1]];
    [self.photoInformationLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.photoInformationLabel];

    UILabel *pedometerLabel = [[UILabel alloc] init];
    [pedometerLabel setText:@"pedometer"];
    [pedometerLabel setFont:titleLabelFont];
    [pedometerLabel sizeToFit];
    [pedometerLabel setFrame:CGRectMake((self.bounds.size.width / 2 ) - pedometerLabel.bounds.size.width - 5,
                                        self.bounds.size.height / 2 + 10,
                                        pedometerLabel.bounds.size.width,
                                        pedometerLabel.bounds.size.height)];
    [pedometerLabel setTextColor:[baseView colorWithRGB:29 :29 :27 :1]];
    [pedometerLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:pedometerLabel];

    self.pedometerInformationLabel = [[UILabel alloc] init];
    [self.pedometerInformationLabel setText:@"pedometer"];
    [self.pedometerInformationLabel setFont:titleLabelFont];
    [self.pedometerInformationLabel sizeToFit];
    [self.pedometerInformationLabel setFrame:CGRectMake((self.bounds.size.width / 2 ) + 5,
                                                        self.bounds.size.height / 2 + 10,
                                                        pedometerLabel.bounds.size.width,
                                                        pedometerLabel.bounds.size.height)];
    [self.pedometerInformationLabel setTextColor:[baseView colorWithRGB:29 :29 :27 :1]];
    [self.pedometerInformationLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.pedometerInformationLabel];

    UILabel *geolocLabel = [[UILabel alloc] init];
    [geolocLabel setText:@"geolocation"];
    [geolocLabel setFont:titleLabelFont];
    [geolocLabel sizeToFit];
    [geolocLabel setFrame:CGRectMake((self.bounds.size.width / 2 ) - (geolocLabel.bounds.size.width / 3 * 2),
                                     self.bounds.size.height / 4 * 3 + 10,
                                     geolocLabel.bounds.size.width,
                                     geolocLabel.bounds.size.height)];
    [geolocLabel setTextColor:[baseView colorWithRGB:29 :29 :27 :1]];
    [geolocLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:geolocLabel];

    self.geolocInformationLabel = [[UILabel alloc] init];
    [self.geolocInformationLabel setText:@"geolocation"];
    [self.geolocInformationLabel setFont:titleLabelFont];
    [self.geolocInformationLabel sizeToFit];
    [self.geolocInformationLabel setFrame:CGRectMake((self.bounds.size.width / 2 ) + (geolocLabel.bounds.size.width / 3) + 10,
                                                     self.bounds.size.height / 4 * 3 + 10,
                                                     geolocLabel.bounds.size.width,
                                                     geolocLabel.bounds.size.height)];
    [self.geolocInformationLabel setTextColor:[baseView colorWithRGB:29 :29 :27 :1]];
    [self.geolocInformationLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.geolocInformationLabel];

}

@end
