//
//  DataInformationView.h
//  Data
//
//  Created by kevin Budain on 04/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface DataInformationView : UIView

@property (nonatomic) UILabel *photoInformationLabel;
@property (nonatomic) UILabel *pedometerInformationLabel;
@property (nonatomic) UILabel *geolocInformationLabel;

- (void)init:(float)size;

@end
