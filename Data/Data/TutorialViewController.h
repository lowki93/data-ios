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

@interface TutorialViewController : UIViewController

@property (nonatomic) UITapGestureRecognizer *informationDataGesture;
@property (nonatomic) UITapGestureRecognizer *closeInformationGesture;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLabelConstraint;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;

@property (weak, nonatomic) IBOutlet UILabel *tutorialLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@property (nonatomic) NSMutableDictionary *parsedData;
@property (retain, nonatomic) Day *tutorialDay;
//@property (retain, nonatomic) ;

@end
