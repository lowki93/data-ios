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
#import "AllDataView.h"
#import "DataViewController.h"

@interface DataView : UIView

@property (nonatomic) NSMutableArray *arrayData;
@property (nonatomic) UIView *contentData;
@property (nonatomic) DataInformationView *informationView;
@property (nonatomic) AllDataView *allDataView;
@property (nonatomic) UIViewController *dataViewController;

- (void)initView:(UIViewController *)dataViewController;
- (void)drawData:(int)indexDay;
- (void)removeBorderButton;

@end