//
//  ProfileVIew.h
//  Data
//
//  Created by kevin Budain on 14/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "LineView.h"

@interface ProfileView : UIView

@property (weak, nonatomic) IBOutlet CustomButton *logoutButton;
@property (weak, nonatomic) IBOutlet CustomButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *visibilyLabel;
@property (weak, nonatomic) IBOutlet UITextField *visibilyTextField;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *stopCaptationButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

- (void)initView:(UIViewController *)dataViewController;
- (void)hideContent;
- (void)showContent;

- (IBAction)hideProfile:(id)sender;

@end