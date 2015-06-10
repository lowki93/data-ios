//
//  SignUpViewController.m
//  Data
//
//  Created by kevin Budain on 09/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "SignUpViewController.h"
#import "PairingViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface SignUpViewController ()

@end

BaseViewController *baseView;

int translation;
float duration;

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    translation = 20;
    duration = 0.55f;

    [self.sigupButton initButton];

    /** title animation **/
    [self animatedView:self.titleLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];

    /** textField animation **/
    [self animatedView:self.usernameTextField Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.mailTextField Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.passwordTextField Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.confirmationPasswordTextField Duration:0 Delay:0 Alpha:0 Translaton:translation];

    /** button animation **/
    [self animatedView:self.sigupButton Duration:0 Delay:0 Alpha:0 Translaton:translation];

    /** line animation **/
    [self animatedView:self.lineView Duration:0 Delay:0 Alpha:0 Translaton:0];

    /** button bottom animation **/
    [self animatedView:self.informationLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.loginButton Duration:0 Delay:0 Alpha:0 Translaton:translation];

    [self performSelector:@selector(firstAnimation) withObject:nil afterDelay:duration];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)firstAnimation {

    [self animatedView:self.titleLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.usernameTextField Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.mailTextField Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.passwordTextField Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.confirmationPasswordTextField Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.sigupButton Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.lineView Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.informationLabel Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.loginButton Duration:duration Delay:duration Alpha:1 Translaton:0];

}

- (IBAction)signupClicked:(id)sender {
//    [self hideContent];
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//
//        [self performSegueWithIdentifier:@"signup_succes" sender:self];
//
//    });
    @try {

        if([[self.mailTextField text] isEqualToString:@""] || [[self.passwordTextField text] isEqualToString:@""] || [[self.confirmationPasswordTextField text] isEqualToString:@""] || [[self.usernameTextField text] isEqualToString:@""]) {
            
            [baseView alertStatus:@"fill in all fields" :@"Sign in Failed!"];
            
        } else if(![[ApiController sharedInstance] NSStringIsValidEmail:[self.mailTextField text]]) {
            
            [baseView alertStatus:@"Please enter an email valid" :@"Sign in Failed!"];

        } else if (![self.passwordTextField.text isEqualToString: self.confirmationPasswordTextField.text]) {
            
            [baseView alertStatus:@"you're 2 passwords are different" :@"Sign up Failed!"];
            
        } else {
            
            NSString *urlString = [[ApiController sharedInstance] getUrlSignUp];

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{
                                         @"email": [[self.mailTextField text] lowercaseString],
                                         @"password": [self.passwordTextField text],
                                         @"username": [self.usernameTextField text]
                                         };
            [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                NSDictionary *dictionary = responseObject[@"user"];
                [[ApiController sharedInstance] setUserLoad:dictionary];
                [[ApiController sharedInstance] updateToken];

                [self hideContent:@"PairingViewController"];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                long responseCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];

                if(responseCode == 409) {
                    [baseView alertStatus:@"Email already used" :@"Sign in Failed!"];
                } else {
                    [baseView alertStatus:@"Connection Failed" :@"Sign in Failed!"];
                }
                
            }];
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [baseView alertStatus:@"Sign in Failed." :@"Error!"];
    }
}

- (IBAction)loginAction:(id)sender {

//    [self hideContent:@"signUp_login"];
    [self hideContent:@"LoginViewController"];

}

- (void)hideContent:(NSString *)string {

    /** title animation **/
    [self animatedView:self.titleLabel Duration:duration Delay:0 Alpha:0 Translaton:0];

    /** textField animation **/
    [self animatedView:self.usernameTextField Duration:duration Delay:0 Alpha:0 Translaton:0];
    [self animatedView:self.mailTextField Duration:duration Delay:0 Alpha:0 Translaton:0];
    [self animatedView:self.passwordTextField Duration:duration Delay:0 Alpha:0 Translaton:0];
    [self animatedView:self.confirmationPasswordTextField Duration:duration Delay:0 Alpha:0 Translaton:0];

    /** button animation **/
    [self animatedView:self.sigupButton Duration:duration Delay:0 Alpha:0 Translaton:0];

    /** line animation **/
    [self animatedView:self.lineView Duration:duration Delay:0 Alpha:0 Translaton:0];

    /** button bottom animation **/
    [self animatedView:self.informationLabel Duration:duration Delay:0 Alpha:0 Translaton:0];
    [self animatedView:self.loginButton Duration:duration Delay:0 Alpha:0 Translaton:0];

    [self performSelector:@selector(segueAfterDelay:) withObject:string afterDelay:duration];

}

- (void)segueAfterDelay:(NSString *)string {
    [self.usernameTextField removeFromSuperview];
    [self.mailTextField removeFromSuperview];
    [self.passwordTextField removeFromSuperview];
    [self.confirmationPasswordTextField removeFromSuperview];
    [self.sigupButton removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.informationLabel removeFromSuperview];
    [self.loginButton removeFromSuperview];
    [self.lineView removeFromSuperview];
    [baseView showModal:string RemoveWindow:false];
}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)animatedView:(UIView *)view Duration:(float)duration Delay:(float)delay Alpha:(float)alpha Translaton:(int)translation{

    [UIView animateWithDuration:duration delay:delay options:0 animations:^{

        [view setAlpha:alpha];
        [view setTransform:CGAffineTransformMakeTranslation(0, translation)];

    } completion:nil];
    
    
}

@end
