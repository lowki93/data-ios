//
//  Data.h
//  Data
//
//  Created by BUDAIN Kevin on 03/04/2015.
//  Copyright (c) 2015 kevin Budain. All rights reserved.
//

#import "JSONModel.h"

@protocol Data
@end

@interface Data : JSONModel

@property(assign, nonatomic) NSDate *date;
//@property(assign, nonatomic) NSObject *atmosphere;

@end