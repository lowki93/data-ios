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
    self.url = [NSString stringWithFormat:@"http://data.vm:5000/api"];
}

- (NSMutableURLRequest *)postRequest:(NSURL *)url Data:(NSData *)postData postLenght:(NSString *)postLength {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    return request;
}

- (NSDictionary *)serializeJson:(NSData *)data Error:(NSError *)error {
    NSDictionary *jsonData = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:NSJSONReadingMutableContainers
                              error:&error];
    return jsonData;
}

- (NSMutableURLRequest *)signUpUser:(NSString *)post {

    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/user/create", self.url]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    return [[ApiController sharedInstance] postRequest:url Data:postData postLenght:postLength];
}

- (NSMutableURLRequest *)signInUser:(NSString *)post {

    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/user/login", self.url]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];

    return [[ApiController sharedInstance] postRequest:url Data:postData postLenght:postLength];
}

- (NSMutableURLRequest *)uploadZip:(NSData *)zipData {
    
    NSString *name = @"ccadc2eb77e12887449101ab1ccc27e8";
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/files/uploads?access_token=%@", self.url, name]];
    NSString *str = @"zip";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831464368775746641449"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"currentEventID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"52344457901000006" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.zip\"\r\n", str, name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: zip\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:zipData];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];

    return request;
}

@end