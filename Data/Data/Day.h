//
//  Day.h
//  Data
//
//  Created by kevin Budain on 09/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "JSONModel.h"
#import "Data.h"

@protocol Day @end

@interface Day : JSONModel

@property(assign, nonatomic) NSString *_id;
@property(assign, nonatomic) NSString *date;
@property(assign, nonatomic) NSArray<Data> *data;

@end