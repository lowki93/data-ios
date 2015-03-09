//
//  LoginViewController.h
//  Data
//
//  Created by kevin Budain on 06/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)signinClicked:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end