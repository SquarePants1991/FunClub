//
// Created by wang yang on 2017/11/20.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import "HTCacheModel.h"
#import "HTCacheTable.h"
#import "HTCache.h"
#import "HTSqlBuilder.h"

#import <objc/runtime.h>

const NSString *kHTCacheModelTableKey;

@interface HTCacheModel() {
    BOOL _isCached;
}
@end

@implementation HTCacheModel
- (id)init {
    if (self = [super init]) {
        _isCached = NO;
    }
    return self;
}

- (void)save {
    if (_isCached) {
        [self update];
    } else {
        [self insert];
    }
}

- (void)insert {
    HTCacheTable *table = [[self class] tableFromCacheModel];
    [table insertValue:[self valuesForFields:table.fields] toFields:table.fields];
    _isCached = YES;
}

- (void)update {
    HTCacheTable *table = [[self class] tableFromCacheModel];
    NSString *sqlValueString = [HTSqlBuilder valueToSqlString:[self valueForKey:[[self class] primaryKey]]];
    NSString *primaryKeyCondition = [NSString stringWithFormat:@"%@ = %@", [[self class] primaryKey], sqlValueString];
    [table updateValue:[self valuesForFields:table.fields] toFields:table.fields where:@[primaryKeyCondition]];
}

+ (void)fetch:(int)skip limit:(int)limit where:(NSArray *)conditions sortedBy:(HTCacheTableField *)sortField isDesc:(BOOL)isDesc completed:(HTCacheModelFetchCompleteHandler)resultHandler {
    HTCacheTable *table = [[self class] tableFromCacheModel];
    [table fetchValues:skip limit:limit fromFields:table.fields where:conditions sortedBy:sortField isDesc:isDesc completed:^(NSArray *result) {
        if (resultHandler) {
            NSMutableArray *models = [NSMutableArray new];
            for (NSDictionary *item in result) {
                id model = [self new];
                [model fillData:item];
                [models addObject:model];
            }
            resultHandler(models);
        }
    }];
}

+ (void)clearCache {
    HTCacheTable *table = [self tableFromCacheModel];
    [table drop];
    objc_setAssociatedObject(self, &kHTCacheModelTableKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Utils

- (NSArray *)valuesForFields:(NSArray *)fields {
    NSMutableArray *values = [NSMutableArray new];
    for (HTCacheTableField *field in fields) {
        id value = [self valueForKey:field.name];
        value = value == nil ? [NSNull null] : value;
        [values addObject:value];
    }
    return [values copy];
}

- (void)fillData:(NSDictionary *)data {
    HTCacheTable *table = [[self class] tableFromCacheModel];
    for (HTCacheTableField *field in table.fields) {
        [self setValue:[data valueForKey:field.name] forKey:field.name];
    }
    _isCached = YES;
}

#pragma mark - Provider Field Attrs

+ (NSArray *)attrsForField:(NSString *)fieldName {
    return @[];
}

+ (NSString *)primaryKey {
    return @"id";
}

#pragma mark - Create Cache Table
+ (HTCacheTable *)tableFromCacheModel {
    HTCacheTable *table = objc_getAssociatedObject(self, &kHTCacheModelTableKey);
    if (table) {
        return table;
    }

    HTCacheTable *cacheTable = [[HTCacheTable alloc] initWithName:NSStringFromClass(self) fields:nil cache:[HTCache standardCache]];
    objc_setAssociatedObject(self, &kHTCacheModelTableKey, cacheTable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    unsigned int propertyCount;
    objc_property_t * propertyPtr = class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i < propertyCount; ++i) {
        objc_property_t propertyValue = *(propertyPtr + i);

        const char * attrs = property_getAttributes(propertyValue);
        NSString *attrString = [NSString stringWithUTF8String:attrs];
        const char * propertyName = property_getName(propertyValue);
        NSString *propertyNameString = [NSString stringWithUTF8String:propertyName];
        NSString *type = [[attrString componentsSeparatedByString:@","] firstObject];
        type = [type substringWithRange:NSMakeRange(3, type.length - 4)];
        Class typeCls = NSClassFromString(type);
        if (typeCls && [typeCls conformsToProtocol:@protocol(HTCacheModelDataTypeProtocol)]) {
            [cacheTable addTableField:[self fieldTypeFromDataTypeClass:typeCls] name:propertyNameString attrs:[self attrsForField:propertyNameString]];
        }
    }

    [cacheTable create];

    return cacheTable;
}

+ (HTCacheTableFieldType)fieldTypeFromDataTypeClass:(Class)dataTypeClass {
    if (dataTypeClass == [HTCInteger class]) {
        return HTCacheTableFieldTypeInteger;
    } else if (dataTypeClass == [HTCNumber class]) {
        return HTCacheTableFieldTypeNumber;
    } else if (dataTypeClass == [HTCText class]) {
        return HTCacheTableFieldTypeText;
    } else if (dataTypeClass == [HTCBlob class]) {
        return HTCacheTableFieldTypeBlob;
    }
    return HTCacheTableFieldTypeInteger;
}
@end