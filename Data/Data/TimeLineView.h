//
//  TimeLineView.h
//  Data
//
//  Created by kevin Budain on 16/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineView : UIView

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, assign) int indexDay;
@property (nonatomic, assign) int nbDay;
@property (nonatomic, assign) int currentDay;

- (void)initTimeLine:(int)nbDay indexDay:(int)indexDay;
- (void)animatedTimeLine:(int)indexDay;

@end