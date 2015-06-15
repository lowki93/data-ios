//
//  CreditView.h
//  Data
//
//  Created by kevin Budain on 14/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface CreditView : UIView

@property (weak, nonatomic) IBOutlet CustomButton *tutorialButton;
@property (weak, nonatomic) IBOutlet UILabel *creditsLabel;

- (void)initView:(UIViewController *)dataViewController HideContent:(BOOL)hide;
- (void)hideContent;
- (void)showContent;

@end