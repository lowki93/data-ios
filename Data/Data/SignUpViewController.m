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

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)signupClicked:(id)sender {
    @try {
        
        if([[self.mailTextField text] isEqualToString:@""] || [[self.passwordTextField text] isEqualToString:@""] || [[self.confirmationPasswordTextField text] isEqualToString:@""] ) {
            
            [self alertStatus:@"Please enter Email and Password" :@"Sign in Failed!" :0];
            
        } else if(![[ApiController sharedInstance] NSStringIsValidEmail:[self.mailTextField text]]) {
            
            [self alertStatus:@"Please enter an email valid" :@"Sign in Failed!" :0];

        } else if (![self.passwordTextField.text isEqualToString: self.confirmationPasswordTextField.text]) {
            
            [self alertStatus:@"you're 2 passwords are different" :@"Sign up Failed!" :0];
            
        } else {
            
            NSString *urlString = [[ApiController sharedInstance] getUrlSignUp];

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{
                                         @"email": [self.mailTextField text],
                                         @"password": [self.passwordTextField text]
                                         };
            [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                User *user = [[User alloc] initWithDictionary:responseObject[@"user"] error:nil];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"user"] forKey:@"user"];
                [ApiController sharedInstance].user = user;
                [self performSegueWithIdentifier:@"signup_succes" sender:self];

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                long responseCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];

                if(responseCode == 409) {
                    [self alertStatus:@"Email already used" :@"Sign in Failed!" :0];
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
                                              cancelButtonTitle:@"ok"
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
