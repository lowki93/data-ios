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

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)signinClicked:(id)sender {
    @try {

        if([[self.usernameTextField text] isEqualToString:@""] || [[self.passwordTextField text] isEqualToString:@""] ) {

            [self alertStatus:@"Please enter Email and Password" :@"Sign in Failed!" :0];

        } else if(![[ApiController sharedInstance] NSStringIsValidEmail:[self.usernameTextField text]]) {

            [self alertStatus:@"Please enter an email valid" :@"Sign in Failed!" :0];

        } else {

            NSString *urlString = [[ApiController sharedInstance] getUrlSignIn];

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{
                                         @"email": [self.usernameTextField text],
                                         @"password": [self.passwordTextField text]
                                        };
            [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                User *user = [[User alloc] initWithDictionary:responseObject[@"user"] error:nil];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"user"] forKey:@"user"];
                [ApiController sharedInstance].user = user;
                [self performSegueWithIdentifier:@"login_succes" sender:self];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                long responseCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];

                if(responseCode == 409 || responseCode == 404) {
                    [self alertStatus:@"Bad credential" :@"Sign in Failed!" :0];
                } else {
                    [self alertStatus:@"Connection Failed" :@"Sign in Failed!" :0];
                }

            }];

        }

    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
