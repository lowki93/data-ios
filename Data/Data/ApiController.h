//
//  ApiController.h
//  Data
//
//  Created by kevin Budain on 09/03/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ApiController : NSObject

@property (nonatomic) NSString *url;
@property (nonatomic) NSDictionary *user;

+ (ApiController *)sharedInstance;
- (void)loadApi;
- (NSMutableURLRequest *)postRequest:(NSURL *)url Data:(NSData *)postData postLenght:(NSString *)postLength;
- (NSDictionary *)serializeJson:(NSData *)data Error:(NSError *)error;
- (NSMutableURLRequest *)signUpUser:(NSString *)post;
- (NSMutableURLRequest *)signInUser:(NSString *)post;

@end