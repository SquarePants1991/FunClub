//
// Created by wang yang on 2017/11/20.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import "HTSqlBuilder.h"


@implementation HTSqlBuilder
+ (NSString *)fieldTypeToSqlString:(HTCacheTableFieldType)type {
    NSDictionary * map = @{
            @(HTCacheTableFieldTypeInteger): @"INTEGER",
            @(HTCacheTableFieldTypeNumber): @"NUMERIC",
            @(HTCacheTableFieldTypeText): @"TEXT",
            @(HTCacheTableFieldTypeBlob): @"BLOB"
    };
    return map[@(type)];
}
+ (NSString *)fieldAttrsToSqlString:(NSArray *)attrs {
    NSDictionary * map = @{
            @(HTCacheTableFieldAttrIsPrimary): @"PRIMARY KEY",
            @(HTCacheTableFieldAttrIsPrimaryAutoInc): @"PRIMARY KEY AUTOINCREMENT",
    };
    NSString * attrString = @" ";
    for (NSNumber *attrValue in attrs) {
        HTCacheTableFieldAttr attr = (HTCacheTableFieldAttr)[attrValue integerValue];
        attrString = [attrString stringByAppendingFormat:@"%@", map[@(attr)]];
    }
    return attrString;
}

+ (NSString *)valueListToSqlString:(NSArray *)values {
    NSMutableArray *processedArray = [NSMutableArray new];
    for (NSValue *val in values) {
        if ([val isKindOfClass:[NSString class]]) {
            [processedArray addObject:[NSString stringWithFormat:@"'%@'", val]];
        } else if ([val isKindOfClass:[NSNumber class]]) {
            [processedArray addObject:[NSString stringWithFormat:@"'%lf'", [(NSNumber *)val doubleValue]]];
        }
    }
    return [processedArray componentsJoinedByString:@","];
}

+ (NSString *)fieldListToSqlString:(NSArray *)fields {
    NSMutableArray *processedArray = [NSMutableArray new];
    for (HTCacheTableField *field in fields) {
        [processedArray addObject:field.name];
    }
    return [processedArray componentsJoinedByString:@","];
}

+ (NSString *)updateListToSqlString:(NSArray *)fields values:(NSArray *)values {
    NSMutableArray *processedArray = [NSMutableArray new];
    int index = 0;
    for (NSValue *val in values) {
        HTCacheTableField *field = fields[index];
        if ([val isKindOfClass:[NSString class]]) {
            [processedArray addObject:[NSString stringWithFormat:@"%@ = '%@'", field.name, val]];
        } else if ([val isKindOfClass:[NSNumber class]]) {
            [processedArray addObject:[NSString stringWithFormat:@"%@ = '%lf'", field.name, [(NSNumber *)val doubleValue]]];
        }
        index++;
    }
    return [processedArray componentsJoinedByString:@","];
}
@end