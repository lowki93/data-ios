//
//  SignUpViewController.m
//  Data
//
//  Created by kevin Budain on 09/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "SignUpViewController.h"

#import "AFHTTPRequestOperationManager.h"

@interface SignUpViewController ()

@end

BaseViewController *baseView;

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    baseView = [[BaseViewController alloc] init];
    [baseView initView:self];

    [self.sigupButton setBackgroundImage:[baseView imageWithColor:baseView.purpleColor] forState:UIControlStateHighlighted];
    [[self.sigupButton layer] setBorderWidth:1.0f];
    [[self.sigupButton layer] setBorderColor:baseView.purpleColor.CGColor];
    [[self.sigupButton layer] setCornerRadius:25];
    [self.sigupButton setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)signupClicked:(id)sender {
    @try {
        
        if([[self.mailTextField text] isEqualToString:@""] || [[self.passwordTextField text] isEqualToString:@""] || [[self.confirmationPasswordTextField text] isEqualToString:@""] ) {
            
            [baseView alertStatus:@"Please enter Email and Password" :@"Sign in Failed!"];
            
        } else if(![[ApiController sharedInstance] NSStringIsValidEmail:[self.mailTextField text]]) {
            
            [baseView alertStatus:@"Please enter an email valid" :@"Sign in Failed!"];

        } else if (![self.passwordTextField.text isEqualToString: self.confirmationPasswordTextField.text]) {
            
            [baseView alertStatus:@"you're 2 passwords are different" :@"Sign up Failed!"];
            
        } else {
            
            NSString *urlString = [[ApiController sharedInstance] getUrlSignUp];

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{
                                         @"email": [self.mailTextField text],
                                         @"password": [self.passwordTextField text]
                                         };
            [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                NSDictionary *dictionary = responseObject[@"user"];
                [[ApiController sharedInstance] setUserLoad:dictionary];
                [[ApiController sharedInstance] updateToken];
                [self performSegueWithIdentifier:@"signup_succes" sender:self];

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
            [self.emailView setBackgroundColor:baseView.purpleColor];
            break;
        case 2:
            [self.firstView setBackgroundColor:baseView.purpleColor];
            break;
        case 3:
            [self.secondView setBackgroundColor:baseView.purpleColor];
            break;
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            [self.emailView setBackgroundColor:baseView.lightGrey];
            break;
        case 2:
            [self.firstView setBackgroundColor:baseView.lightGrey];
            break;
        case 3:
            [self.secondView setBackgroundColor:baseView.lightGrey];
            break;
        default:
            break;
    }
}

@end
