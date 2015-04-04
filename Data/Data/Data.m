//
//  Data.m
//  Data
//
//  Created by BUDAIN Kevin on 03/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "Data.h"

@implementation Data

JSONValueTransformer *transformer;

-(id)initWithDictionary:(NSDictionary*)dictionary error:(NSError *__autoreleasing *)err
{
    self = [super init];

    if (self) {
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:[dictionary[@"date"] intValue]];
        self.date = date;
        self.atmosphere = dictionary[@"atmosphere"];
    }

    return self;
}

@end