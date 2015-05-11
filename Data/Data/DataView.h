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

@interface DataView : UIView

@property (nonatomic) NSMutableArray *arrayData;
@property (nonatomic) UIView *contentData;
@property (nonatomic) DataInformationView *informationView;

- (void)initView;
- (void)drawData:(int)indexDay;
- (void)removeBorderButton;
//- (void)updateDataContent:(UIView *)view Float:(float)scale;
- (void)updateDataContent:(CGRect)frame Float:(float)scale;

@end