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

@property(assign, nonatomic) NSString *id;
@property(assign, nonatomic) NSString *email;
@property(assign, nonatomic) NSString *token;
@property(assign, nonatomic) Experience<Optional> *currentData;

@end