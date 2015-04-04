//
//  Data.h
//  Data
//
//  Created by BUDAIN Kevin on 03/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "JSONModel.h"
#import "JSONValueTransformer.h"

@interface Data : JSONModel

@property(assign, nonatomic) NSDate *date;
@property(assign, nonatomic) NSObject *atmosphere;

-(id)initWithDictionary:(NSDictionary*)dictionary error:(NSError *__autoreleasing *)err;

@end