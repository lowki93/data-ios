//
//  LoginViewController.m
//  Data
//
//  Created by kevin Budain on 06/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

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

        } else {

            NSString *post =[[NSString alloc] initWithFormat:@"email=%@&password=%@",[self.usernameTextField text],[self.passwordTextField text]];

            NSMutableURLRequest *request = [[ApiController sharedInstance] signInUser:post];

            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

            if ((long)[response statusCode] == 200) {
                NSError *error = nil;
                NSDictionary *jsonData = [[ApiController sharedInstance] serializeJson:urlData Error:error];
                User *user = [[User alloc] initWithDictionary:jsonData[@"user"] error:nil];
                [[NSUserDefaults standardUserDefaults] setObject:jsonData[@"user"] forKey:@"user"];
                [ApiController sharedInstance].user = user;
                [self performSegueWithIdentifier:@"login_succes" sender:self];
            } else if((long)[response statusCode] == 409 || (long)[response statusCode] == 404) {
                NSError *error = nil;
                NSDictionary *jsonData = [[ApiController sharedInstance] serializeJson:urlData Error:error];
                [self alertStatus:jsonData[@"error"] :@"Sign in Failed!" :0];
            } else {
                [self alertStatus:@"Connection Failed" :@"Sign in Failed!" :0];
            }

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
