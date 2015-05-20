//
//  User.h
//  Data
//
//  Created by BUDAIN Kevin on 02/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "JSONModel.h"
#import "Experience.h"

@interface User : JSONModel

@property(assign, nonatomic) NSString *_id;
@property(assign, nonatomic) NSString *email;
@property(assign, nonatomic) NSString *username;
@property(assign, nonatomic) NSString<Optional> *deviceToken;
@property(assign, nonatomic) NSString *token;
@property(assign, nonatomic) BOOL isActive;
@property(assign, nonatomic) Experience<Optional> *currentData;

@end