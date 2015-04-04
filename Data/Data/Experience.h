//
//  Experience.h
//  Data
//
//  Created by BUDAIN Kevin on 03/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "JSONModel.h"
#import "Data.h"

@protocol Experience
@end

@interface Experience : JSONModel

@property(assign, nonatomic) NSString *id;
@property(assign, nonatomic) NSString<Optional> *title;
@property(assign, nonatomic) NSString<Optional> *descriptionContent;
@property(assign, nonatomic) BOOL private;
@property(assign, nonatomic) NSArray<Data, Optional> *data;

@end