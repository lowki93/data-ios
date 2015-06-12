//
//  DataView.h
//  Data
//
//  Created by kevin Budain on 30/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DataInformationView.h"
#import "DataViewController.h"
#import "TutorialViewController.h"
#import "CaptationImageView.h"

#import "ClickImageView.h"

@interface DataView : UIView

@property (nonatomic) NSMutableArray *arrayData;
@property (nonatomic) UILabel *hoursLabel;
@property (nonatomic) UIView *contentData;
@property (nonatomic) DataInformationView *informationView;
@property (nonatomic) DataInformationView *allDataView;
@property (nonatomic) CaptationImageView *captationImageView;
@property (nonatomic) ClickImageView *selectedButtonImageView;

@property (nonatomic) bool informationButton;
@property (nonatomic) bool informationViewActive;
@property (nonatomic) int nbPhoto;
@property (nonatomic) int nbGeoloc;
@property (nonatomic) float distance;
@property (nonatomic) float delay;
@property (nonatomic) CAGradientLayer *gradientLayer;
@property (nonatomic) NSTimer *timeSelectedButton;
@property (nonatomic) NSMutableArray *buttonArray;

- (void)initView:(UIViewController *)viewController;
- (void)drawData:(int)indexDay;
- (void)removeBorderButton;
- (void)scaleInformationView:(UIView *)view;
- (void)generateDataAfterSynchro:(Day *)currentDay;
- (void)activeCapta;
- (void)removeCapta;
- (void)animatedCaptionImageView:(float)alpha;
- (void)generateData:(int)index Day:(Day *)day;
- (void)addActionForButton;
- (void)removeActionForButton;
- (void)updateAllInformation;
- (void)writeSelecteButtonView:(int)index;
- (void)hideButton;
- (void)showButton;

@end