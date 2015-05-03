//
//  ChooseDayViewController.h
//  Data
//
//  Created by kevin Budain on 01/05/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseDayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *dayScrollView;
@property (weak, nonatomic) IBOutlet UIButton *validateButton;

- (IBAction)validateAction:(id)sender;

@end