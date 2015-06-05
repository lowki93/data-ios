//
//  TutorialViewController.h
//  Data
//
//  Created by kevin Budain on 26/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"
#import "DataView.h"
#import "TutorialPullUpView.h"
#import "customPageControl.h"

@interface TutorialViewController : UIViewController

@property (weak, nonatomic) IBOutlet TutorialPullUpView *tutorialTimeLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLabelConstraint;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *tutorialLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@property (nonatomic, strong) IBOutlet customPageControl *pageControl;

@property (nonatomic) UITapGestureRecognizer *informationDataGesture;
@property (nonatomic) UITapGestureRecognizer *closeInformationGesture;

@property (nonatomic) NSMutableDictionary *parsedData;
@property (retain, nonatomic) Day *tutorialDay;

@end
