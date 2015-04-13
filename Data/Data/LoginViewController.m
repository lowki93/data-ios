//
//  LoginViewController.m
//  Data
//
//  Created by kevin Budain on 06/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

#import "AFHTTPRequestOperationManager.h"

@interface LoginViewController (){
  NSArray* items;
}
@end

BaseViewController *baseView;

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];
    
    [self.loginButton setBackgroundImage:[baseView imageWithColor:baseView.purpleColor] forState:UIControlStateHighlighted];
    [[self.loginButton layer] setBorderWidth:1.0f];
    [[self.loginButton layer] setBorderColor:baseView.purpleColor.CGColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
                                         @"email": [self.usernameTextField text],
                                         @"password": [self.passwordTextField text]
                                        };
            [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                NSDictionary *dictionary = responseObject[@"user"];
                [[ApiController sharedInstance] setUserLoad:dictionary];
                [self performSegueWithIdentifier:@"login_succes" sender:self];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            [self.usernameView setBackgroundColor:baseView.purpleColor];
            break;
        case 2:
            [self.passwordView setBackgroundColor:baseView.purpleColor];
            break;
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            [self.usernameView setBackgroundColor:baseView.lightGrey];
            break;
        case 2:
            [self.passwordView setBackgroundColor:baseView.lightGrey];
            break;
        default:
            break;
    }
}

@end
