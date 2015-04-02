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
- (NSMutableURLRequest *)postRequest:(NSURL *)url Data:(NSData *)postData postLenght:(NSString *)postLength;
- (NSDictionary *)serializeJson:(NSData *)data Error:(NSError *)error;
- (NSMutableURLRequest *)signUpUser:(NSString *)post;
- (NSMutableURLRequest *)signInUser:(NSString *)post;
- (NSMutableURLRequest *)updateData:(NSString *)post;
- (NSMutableURLRequest *)uploadZip:(NSData *)zipData;

@end