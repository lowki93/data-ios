//
//  ApiController.h
//  Data
//
//  Created by kevin Budain on 09/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"

@interface ApiController : NSObject

@property (nonatomic) NSString *url;
@property (nonatomic) User *user;

+ (ApiController *)sharedInstance;
- (void)loadApi;
- (NSString *)getUrlSignIn;
- (NSString *)getUrlSignUp;
- (NSString *)getUrlUploadImages;
- (NSString *)getUrlUploadData;
- (BOOL)NSStringIsValidEmail:(NSString *)checkString;

@end