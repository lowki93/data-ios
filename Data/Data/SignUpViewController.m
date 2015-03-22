//
//  SignUpViewController.m
//  Data
//
//  Created by kevin Budain on 09/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "SignUpViewController.h"

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
            
        } else if(![self NSStringIsValidEmail:[self.mailTextField text]]) {
            
            [self alertStatus:@"Please enter an email valid" :@"Sign in Failed!" :0];

        } else if (![self.passwordTextField.text isEqualToString: self.confirmationPasswordTextField.text]) {
            
            [self alertStatus:@"you're 2 passwords are different" :@"Sign up Failed!" :0];
            
        } else {
            
            NSString *post =[[NSString alloc] initWithFormat:@"email=%@&password=%@",[self.mailTextField text],[self.passwordTextField text]];
            
            NSMutableURLRequest *request = [[ApiController sharedInstance] signUpUser:post];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if ((long)[response statusCode] == 201) {
                NSError *error = nil;
                NSDictionary *jsonData = [[ApiController sharedInstance] serializeJson:urlData Error:error];
                [[NSUserDefaults standardUserDefaults] setObject:jsonData[@"user"][@"token"] forKey:@"user"];
                [ApiController sharedInstance].user = jsonData[@"user"];
                [self performSegueWithIdentifier:@"signup_succes" sender:self];
            } else if((long)[response statusCode] == 409) {
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
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

- (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
   
@end
