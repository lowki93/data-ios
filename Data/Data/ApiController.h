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
#import "Experience.h"
#import "Data.h"

@interface ApiController : NSObject

@property (nonatomic) NSString *url;
@property (nonatomic) User *user;
@property (nonatomic) Experience *experience;

+ (ApiController *)sharedInstance;
- (void)loadApi;
- (void)setUserLoad:(NSDictionary *)dictionary;
- (NSDate *)getCurrentDate;
- (NSString *)getUrlSignIn;
- (NSString *)getUrlSignUp;
- (NSString *)getUrlUploadImages;
- (NSString *)getUrlUploadData;
- (NSString *)getUrlExperienceCreate;
- (BOOL)NSStringIsValidEmail:(NSString *)checkString;
- (Data *)GetLastData;
- (int)getIndexData;

@end