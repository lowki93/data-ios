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
#import "JFRWebSocket.h"

@interface ApiController : NSObject

@property (nonatomic) NSString *url;
@property (nonatomic) NSString *socketUrl;
@property (nonatomic) User *user;
@property (nonatomic) Experience *experience;
@property (nonatomic) NSMutableArray *location;
@property (nonatomic) long nbDay;

@property(nonatomic) JFRWebSocket *socket;

+ (ApiController *)sharedInstance;
- (void)loadApi;
- (void)setUserLoad:(NSDictionary *)dictionary;
- (void)removeUser;
- (NSString *)getDateWithTime;
- (NSString *)getDate;
- (NSString *)getUrlSignIn;
- (NSString *)getUrlSignUp;
- (NSString *)getUrlUploadImages;
- (NSString *)getUrlUploadData;
- (NSString *)getUrlExperienceCreate;
- (NSString *)getUrlParringGeoloc:(NSString *)idString Token:(NSString *)tokenString;
- (NSString *)getUrlExperienceDate;
- (NSString *)getUrlUploadPodometer;
- (BOOL)NSStringIsValidEmail:(NSString *)checkString;
- (Data *)GetLastData;
- (int)getIndexData;
- (void)updateToken;
- (JFRWebSocket *)activeSocket:(UIViewController *)viewController;
- (void)writeDataSocket:(NSString *)string;

@end