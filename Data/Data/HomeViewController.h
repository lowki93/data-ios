//
//  HomeViewController.h
//  Data
//
//  Created by kevin Budain on 05/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet CustomButton *signUpButton;
@property (weak, nonatomic) IBOutlet CustomButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)signupAction:(id)sender;
- (IBAction)loginAction:(id)sender;

@end
