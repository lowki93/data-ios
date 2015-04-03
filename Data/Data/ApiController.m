//
//  ApiController.m
//  Data
//
//  Created by kevin Budain on 09/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "ApiController.h"

@implementation ApiController

+ (ApiController *)sharedInstance
{
    static ApiController *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ApiController alloc] init];
        [sharedInstance loadApi];
    });
    return sharedInstance;
}

- (void)loadApi {
    // local
    self.url = [NSString stringWithFormat:@"http://data.vm:5000/api"];
    // ip pc test phone
//    self.url = [NSString stringWithFormat:@"http://172.18.35.1:5000/api"];
}



- (NSString *)getUrlSignIn {

    return [NSString stringWithFormat:@"%@/user/login", self.url];

}

- (NSString *)getUrlSignUp {

    return [NSString stringWithFormat:@"%@/user/create", self.url];
    
}

- (NSString *)getUrlUploadImages {

    return [NSString stringWithFormat:@"%@/files/uploads?access_token=%@", self.url, self.user.token];

}

- (NSString *)getUrlUploadData {

    return [NSString stringWithFormat:@"%@/data/%@/save?access_token=%@", self.url, self.user.id, self.user.token];

}

- (NSString *)getUrlExperienceCreate {

    return [NSString stringWithFormat:@"%@/experience/%@/create?access_token=%@", self.url, self.user.id, self.user.token];
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


@end