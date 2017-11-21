//
//  HTCacheTable.m
//  FunClub
//
//  Created by wang yang on 2017/11/17.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "HTCacheTable.h"
#import "HTCache.h"
#import "HTSqlBuilder.h"

@implementation HTCacheTableField
- (id)initWithName:(NSString *)name type:(HTCacheTableFieldType)type attrs:(NSArray *)attrs {
    if (self = [super init]) {
        self.name = name;
        self.attrs = attrs;
        self.type = type;
    }
    return self;
}

+ (id)fieldWithName:(NSString *)name type:(HTCacheTableFieldType)type {
    return [[HTCacheTableField alloc] initWithName:name type:type attrs:nil];
}
@end

@implementation HTCacheTable
@synthesize cache;
- (id)initWithName:(NSString *)name fields:(NSArray *)fields cache:(HTCache *)cache {
    if (self = [super init]) {
        self.name = name;
        self.fields = fields;
        self.cache = cache;
    }
    return self;
}

- (void)addTableField:(HTCacheTableFieldType)type name:(NSString *)fieldName attrs:(NSArray *)attrs {
    HTCacheTableField *field = [HTCacheTableField new];
    field.name = fieldName;
    field.type = type;
    field.attrs = attrs;
    self.fields = self.fields ? [self.fields arrayByAddingObject:field] : @[field];
}

- (BOOL)create {
    NSMutableArray *fieldList = [NSMutableArray new];
    for (HTCacheTableField *field in self.fields) {
        NSString *fieldString = [NSString stringWithFormat:@"%@ %@ %@\n", field.name,
                        [HTSqlBuilder fieldTypeToSqlString:field.type],
                        [HTSqlBuilder fieldAttrsToSqlString:field.attrs]];
        [fieldList addObject:fieldString];
    }
    NSString * fieldListString = [fieldList componentsJoinedByString:@","];
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(%@)", self.name, fieldListString];
    return [cache executeSql:sql completed:^(NSDictionary *resultSets) {

    }];
}

- (BOOL)drop {
    NSString *sql = [NSString stringWithFormat:@"drop table %@", self.name];
    return [cache executeSql:sql completed:^(NSDictionary *resultSets) {

    }];
}

- (void)isExistWithCompleted:(HTCacheTableBoolOperationHandler)resultHandler {
    NSString * selectSql = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'", self.name];
    [cache executeSql:selectSql completed:^(NSDictionary *resultSets) {
        if (resultHandler) {
            if (resultSets && [resultSets[@"name"] isEqualToString:self.name]) {
                resultHandler(YES);
            } else {
                resultHandler(NO);
            }
        }
    }];
}

- (BOOL)insertValue:(NSArray *)values toFields:(NSArray *)fields {
    NSString *valueList = [HTSqlBuilder valueListToSqlString:values];
    NSString *fieldList = [HTSqlBuilder fieldListToSqlString:fields];
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values(%@)", self.name, fieldList, valueList];
    return [cache executeSql:sql completed:^(NSDictionary *resultSets) {

    }];
}

- (BOOL)updateValue:(NSArray *)values toFields:(NSArray *)fields where:(NSArray *)conditions {
    NSString * whereConditionsString = @"";
    if (conditions.count > 0) {
        whereConditionsString = [NSString stringWithFormat:@"where %@", [conditions componentsJoinedByString:@" and "]];
    }
    NSString *updateList = [HTSqlBuilder updateListToSqlString:fields values:values];
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ %@", self.name, updateList, whereConditionsString];
    return [cache executeSql:sql completed:^(NSDictionary *resultSets) {
    }];
}

- (void)fetchValues:(int)skip limit:(int)limit fromFields:(NSArray *)fields completed:(HTCacheTableFetchListOperationHandler)resultHandler {
    [self fetchValues:skip limit:limit fromFields:fields where:nil sortedBy:nil isDesc:NO completed:resultHandler];
}

- (void)fetchValues:(int)skip limit:(int)limit fromFields:(NSArray *)fields sortedBy:(HTCacheTableField *)field isDesc:(BOOL)isDesc completed:(HTCacheTableFetchListOperationHandler)resultHandler {
    [self fetchValues:skip limit:limit fromFields:fields where:nil sortedBy:field isDesc:isDesc completed:resultHandler];
}

- (void)fetchValues:(int)skip limit:(int)limit fromFields:(NSArray *)fields where:(NSArray *)conditions sortedBy:(HTCacheTableField *)sortField isDesc:(BOOL)isDesc completed:(HTCacheTableFetchListOperationHandler)resultHandler {
    NSString * whereConditionsString = @"";
    if (conditions.count > 0) {
        whereConditionsString = [NSString stringWithFormat:@"where %@", [conditions componentsJoinedByString:@" and "]];
    }
    NSString * sortMethod = isDesc ? @"desc" : @"asc";
    NSString *sortClauseString = sortField ? [NSString stringWithFormat:@"order by %@ %@", sortField.name, sortMethod] : @"";
    NSString *fieldList = [HTSqlBuilder fieldListToSqlString:fields];
    NSString *sql = [NSString stringWithFormat:@"select %@ from %@ %@ %@ limit %d offset %d", fieldList, self.name, whereConditionsString, sortClauseString, limit, skip];
    [cache executeQuery:sql completed:^(NSArray *results) {
        if (resultHandler) {
            resultHandler(results);
        }
    }];
}
@end
