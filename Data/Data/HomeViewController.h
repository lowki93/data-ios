//
//  HomeViewController.h
//  Data
//
//  Created by kevin Budain on 05/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"
#import "HomeView.h"
#import "LoginView.h"
#import "SignUpView.h"

@interface HomeViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet PlayerView *playerView;
@property (weak, nonatomic) IBOutlet HomeView *homeView;
@property (weak, nonatomic) IBOutlet LoginView *loginView;
@property (weak, nonatomic) IBOutlet SignUpView *signUpView;


- (IBAction)homeLoginAction:(id)sender;
- (IBAction)homeSignUpAction:(id)sender;
- (IBAction)loginSignUpAction:(id)sender;
- (IBAction)loginConnectActiopn:(id)sender;
- (IBAction)signUpLoginAction:(id)sender;
- (IBAction)signUpSignAction:(id)sender;

@end
