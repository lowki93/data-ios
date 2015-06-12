//
//  LoginView.h
//  Data
//
//  Created by kevin Budain on 12/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface LoginView : UIView

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet CustomButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

- (void)initView:(UIViewController *)homeViewController;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)signUpAction:(id)sender;
- (void)showContent;
- (void)hideContent;

@end
