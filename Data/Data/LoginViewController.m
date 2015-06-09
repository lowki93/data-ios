//
//  LoginViewController.m
//  Data
//
//  Created by kevin Budain on 06/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "PairingViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface LoginViewController ()
@end

BaseViewController *baseView;

int translation;
float duration;

@implementation LoginViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    translation = 20;
    duration = 0.55f;
    
    [self.loginButton initButton];
    
    /** title animation **/
    [self animatedView:self.titleLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];

    /** textField animation **/
    [self animatedView:self.usernameTextField Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.passwordTextField Duration:0 Delay:0 Alpha:0 Translaton:translation];

    /** button animation **/
    [self animatedView:self.loginButton Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.forgotPasswordButton Duration:0 Delay:0 Alpha:0 Translaton:translation];

    /** line animation **/
    [self animatedView:self.lineView Duration:0 Delay:0 Alpha:0 Translaton:0];

    /** button bottom animation **/
    [self animatedView:self.informationLabel Duration:0 Delay:0 Alpha:0 Translaton:translation];
    [self animatedView:self.signUpButton Duration:0 Delay:0 Alpha:0 Translaton:translation];

    [self performSelector:@selector(firstAnimation) withObject:nil afterDelay:duration];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)firstAnimation {

    [self animatedView:self.titleLabel Duration:duration Delay:0 Alpha:1 Translaton:0];
    [self animatedView:self.usernameTextField Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.passwordTextField Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.loginButton Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.forgotPasswordButton Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.lineView Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.informationLabel Duration:duration Delay:duration Alpha:1 Translaton:0];
    [self animatedView:self.signUpButton Duration:duration Delay:duration Alpha:1 Translaton:0];

}

- (IBAction)signinClicked:(id)sender {
    @try {

        if([[self.usernameTextField text] isEqualToString:@""] || [[self.passwordTextField text] isEqualToString:@""] ) {

            [baseView alertStatus:@"Please enter Email and Password" :@"Sign in Failed!"];

        } else if(![[ApiController sharedInstance] NSStringIsValidEmail:[self.usernameTextField text]]) {

            [baseView alertStatus:@"Please enter an email valid" :@"Sign in Failed!"];

        } else {

            NSString *urlString = [[ApiController sharedInstance] getUrlSignIn];

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{
                                         @"email": [[self.usernameTextField text] lowercaseString],
                                         @"password": [self.passwordTextField text]
                                        };
            [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                NSDictionary *dictionary = responseObject[@"user"];
                [[ApiController sharedInstance] setUserLoad:dictionary];
                [[ApiController sharedInstance] updateToken];
                [self hideContent];

                if(![ApiController sharedInstance].user.isActive) {

                    [self performSelector:@selector(segueAfterDelay:) withObject:@"login_pairing" afterDelay:duration];
                    
                } else {

                    [self performSelector:@selector(segueAfterDelay:) withObject:@"login_succes" afterDelay:duration];

                }

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                NSLog(@"%@", error);

                long responseCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];

                if(responseCode == 409 || responseCode == 404) {
                    [baseView alertStatus:@"Bad credential" :@"Sign in Failed!"];
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

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (void)hideContent {

    /** title animation **/
    [self animatedView:self.titleLabel Duration:duration Delay:0 Alpha:0 Translaton:0];

    /** textField animation **/
    [self animatedView:self.usernameTextField Duration:duration Delay:0 Alpha:0 Translaton:0];
    [self animatedView:self.passwordTextField Duration:duration Delay:0 Alpha:0 Translaton:0];

    /** button animation **/
    [self animatedView:self.loginButton Duration:duration Delay:0 Alpha:0 Translaton:0];
    [self animatedView:self.forgotPasswordButton Duration:duration Delay:0 Alpha:0 Translaton:0];

    /** line animation **/
    [self animatedView:self.lineView Duration:duration Delay:duration Alpha:0 Translaton:0];

    /** button bottom animation **/
    [self animatedView:self.informationLabel Duration:duration Delay:0 Alpha:0 Translaton:0];
    [self animatedView:self.signUpButton Duration:duration Delay:0 Alpha:0 Translaton:0];

}

- (IBAction)signUpAction:(id)sender {

    [self hideContent];
//[self dismissModalViewControllerAnimated:YES];
    [self performSelector:@selector(segueAfterDelay:) withObject:@"login_signUp" afterDelay:duration];
//    [self performSelector:@selector(segueAfterDelay:) withObject:@"SignUpViewController" afterDelay:duration];

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

- (void)segueAfterDelay:(NSString *)string {
    [self performSegueWithIdentifier:string sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"login_pairing"]) {

        PairingViewController *pairingViewController = [segue destinationViewController];
        pairingViewController.isSignUp = true;
    }
}

@end
