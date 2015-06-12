//
//  HomeViewController.m
//  Data
//
//  Created by kevin Budain on 05/06/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "HomeViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface HomeViewController ()

@end

BaseViewController *baseView;

float duration;

@implementation HomeViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    baseView = [[BaseViewController alloc] init];

    duration = 0.8;

    [self.loginView setHidden:YES];
    [self.signUpView setHidden:YES];

    [self.playerView initPlayer:@"home" View:self.view];
    [self.homeView initView:self];
    [self.signUpView initView:self];
    [self.loginView initView:self];

    [baseView animatedView:self.playerView Duration:0 Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
    [baseView animatedView:self.playerView Duration:0.5 Delay:0.5 Alpha:1 TranslationX:0 TranslationY:0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)homeLoginAction:(id)sender {

    [self.loginView performSelector:@selector(showContent) withObject:nil afterDelay:duration];
    [self.loginView setHidden:NO];

}

- (IBAction)homeSignUpAction:(id)sender {

    [self.signUpView performSelector:@selector(showContent) withObject:nil afterDelay:duration];
    [self.signUpView setHidden:NO];

}

- (IBAction)loginSignUpAction:(id)sender {

    [self.signUpView setHidden:NO];
    [self.signUpView performSelector:@selector(showContent) withObject:nil afterDelay:duration];

}

- (IBAction)loginConnectActiopn:(id)sender {

    @try {

        if([[self.loginView.usernameTextField text] isEqualToString:@""] || [[self.loginView.passwordTextField text] isEqualToString:@""] ) {

            [baseView alertStatus:@"Please enter Email and Password" :@"Sign in Failed!"];

        } else if(![[ApiController sharedInstance] NSStringIsValidEmail:[self.loginView.usernameTextField text]]) {

            [baseView alertStatus:@"Please enter an email valid" :@"Sign in Failed!"];

        } else {

            NSString *urlString = [[ApiController sharedInstance] getUrlSignIn];

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{
                                         @"email": [[self.loginView.usernameTextField text] lowercaseString],
                                         @"password": [self.loginView.passwordTextField text]
                                         };
            [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                NSDictionary *dictionary = responseObject[@"user"];
                [[ApiController sharedInstance] setUserLoad:dictionary];
                [[ApiController sharedInstance] updateToken];
                [self.loginView hideContent];

                [baseView animatedView:self.playerView Duration:0.5 Delay:0 Alpha:0 TranslationX:0 TranslationY:0];

                if(![ApiController sharedInstance].user.isActive) {

                    [self performSelector:@selector(executeSegue:) withObject:@"home_pairing" afterDelay:duration];

                } else {

                    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{

                        [self.view setBackgroundColor:[UIColor whiteColor]];

                    } completion:nil];

                    [self performSelector:@selector(executeSegue:) withObject:@"home_data" afterDelay:duration];

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

- (IBAction)signUpLoginAction:(id)sender {

    [self.loginView setHidden:NO];
    [self.loginView performSelector:@selector(showContent) withObject:nil afterDelay:duration];

}

- (IBAction)signUpSignAction:(id)sender {

    @try {

        if([[self.signUpView.mailTextField text] isEqualToString:@""] || [[self.signUpView.passwordTextField text] isEqualToString:@""] || [[self.signUpView.confirmationPasswordTextField text] isEqualToString:@""] || [[self.signUpView.usernameTextField text] isEqualToString:@""]) {

            [baseView alertStatus:@"fill in all fields" :@"Sign in Failed!"];

        } else if(![[ApiController sharedInstance] NSStringIsValidEmail:[self.signUpView.mailTextField text]]) {

            [baseView alertStatus:@"Please enter an email valid" :@"Sign in Failed!"];

        } else if (![self.signUpView.passwordTextField.text isEqualToString: self.signUpView.confirmationPasswordTextField.text]) {

            [baseView alertStatus:@"you're 2 passwords are different" :@"Sign up Failed!"];

        } else {

            NSString *urlString = [[ApiController sharedInstance] getUrlSignUp];

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{
                                         @"email": [[self.signUpView.mailTextField text] lowercaseString],
                                         @"password": [self.signUpView.passwordTextField text],
                                         @"username": [self.signUpView.usernameTextField text]
                                         };
            [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                NSDictionary *dictionary = responseObject[@"user"];
                [[ApiController sharedInstance] setUserLoad:dictionary];
                [[ApiController sharedInstance] updateToken];

                NSLog(@"user create");
                [self.signUpView hideContent];
                [baseView animatedView:self.playerView Duration:0.5 Delay:0 Alpha:0 TranslationX:0 TranslationY:0];
                [self performSelector:@selector(executeSegue:) withObject:@"home_pairing" afterDelay:duration];

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

- (void)executeSegue:(NSString *)string {
    
    [self performSegueWithIdentifier:string sender:self];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
    
}


@end
