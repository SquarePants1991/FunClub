//
// Created by wang yang on 2017/11/20.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCacheTable.h"

@interface HTSqlBuilder : NSObject
+ (NSString *)fieldTypeToSqlString:(HTCacheTableFieldType)type;
+ (NSString *)fieldAttrsToSqlString:(NSArray *)attrs;
+ (NSString *)valueListToSqlString:(NSArray *)values;
+ (NSString *)fieldListToSqlString:(NSArray *)fields;
+ (NSString *)updateListToSqlString:(NSArray *)fields values:(NSArray *)values;
@end