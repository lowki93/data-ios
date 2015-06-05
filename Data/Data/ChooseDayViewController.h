//
//  ChooseDayViewController.h
//  Data
//
//  Created by kevin Budain on 01/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface ChooseDayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *dayScrollView;
@property (weak, nonatomic) IBOutlet CustomButton *validateButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

- (IBAction)validateAction:(id)sender;

@end