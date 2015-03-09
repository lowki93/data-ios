//
//  LoginViewController.m
//  Data
//
//  Created by kevin Budain on 06/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)signinClicked:(id)sender {
    NSInteger success = 0;
    @try {
        
        if([[self.usernameTextField text] isEqualToString:@""] || [[self.passwordTextField text] isEqualToString:@""] ) {
            
            [self alertStatus:@"Please enter Email and Password" :@"Sign in Failed!" :0];
            
        } else {
            //            NSString *post =[[NSString alloc] initWithFormat:@"username=%@&password=%@",[self.txtUsername text],[self.txtPassword text]];
//            NSLog(@"PostData: %@",post);
//            
//            NSURL *url=[NSURL URLWithString:@"https://dipinkrishna.com/jsonlogin.php"];
//            
//            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//            
//            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//            
//            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//            [request setURL:url];
//            [request setHTTPMethod:@"POST"];
//            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [request setHTTPBody:postData];
//            
//            //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
//            
//            NSError *error = [[NSError alloc] init];
//            NSHTTPURLResponse *response = nil;
//            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//            
//            NSLog(@"Response code: %ld", (long)[response statusCode]);
//            
//            if ([response statusCode] >= 200 && [response statusCode] < 300)
//            {
//                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
//                NSLog(@"Response ==> %@", responseData);
//                
//                NSError *error = nil;
//                NSDictionary *jsonData = [NSJSONSerialization
//                                          JSONObjectWithData:urlData
//                                          options:NSJSONReadingMutableContainers
//                                          error:&error];
//                
//                success = [jsonData[@"success"] integerValue];
//                NSLog(@"Success: %ld",(long)success);
//                
//                if(success == 1)
//                {
//                    NSLog(@"Login SUCCESS");
//                } else {
//                    
//                    NSString *error_msg = (NSString *) jsonData[@"error_message"];
//                    [self alertStatus:error_msg :@"Sign in Failed!" :0];
//                }
//                
//            } else {
//                //if (error) NSLog(@"Error: %@", error);
//                [self alertStatus:@"Connection Failed" :@"Sign in Failed!" :0];
//            }
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
