//
//  Data.h
//  Data
//
//  Created by BUDAIN Kevin on 03/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "JSONModel.h"

@protocol Data @end

@interface Data : JSONModel

@property(assign, nonatomic) NSString<Optional> *_id;
@property(assign, nonatomic) NSString *date;
@property(assign, nonatomic) NSArray<NSObject, Optional> *atmosphere;
@property(assign, nonatomic) NSDictionary <Optional> *deplacement;
@property(assign, nonatomic) NSArray<NSObject, Optional> *photos;

@end