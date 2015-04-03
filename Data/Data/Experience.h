//
//  Experience.h
//  Data
//
//  Created by BUDAIN Kevin on 03/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "JSONModel.h"
#import "Data.h"

@interface Experience : JSONModel

@property(assign, nonatomic) NSString *id;
@property(assign, nonatomic) NSString<Optional> *title;
@property(assign, nonatomic) NSString<Optional> *description;
@property(assign, nonatomic) BOOL *private;
@property(assign, nonatomic) Data<Optional> *data;

@end
