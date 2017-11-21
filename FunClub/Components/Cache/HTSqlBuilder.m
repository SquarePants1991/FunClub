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

+ (NSString *)valueToSqlString:(id)val {
    if ([val isKindOfClass:[NSNull class]]) {
        return @"null";
    }
    if ([val isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"'%@'", val];
    } else if ([val isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"'%lf'", [(NSNumber *)val doubleValue]];
    }
    return @"";
}

+ (NSString *)valueListToSqlString:(NSArray *)values {
    NSMutableArray *processedArray = [NSMutableArray new];
    for (NSValue *val in values) {
        [processedArray addObject:[self valueToSqlString:val]];
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
        [processedArray addObject:[NSString stringWithFormat:@"%@ = %@", field.name, [self valueToSqlString:val]]];
        index++;
    }
    return [processedArray componentsJoinedByString:@","];
}
@end