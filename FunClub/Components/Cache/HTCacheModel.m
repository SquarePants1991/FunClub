//
// Created by wang yang on 2017/11/20.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import "HTCacheModel.h"
#import "HTCacheTable.h"
#import "HTCache.h"

#import <objc/runtime.h>

@implementation HTCacheModel
- (void)insert {

}

+ (HTCacheTable *)tableFromCacheModel {
    HTCacheTable *cacheTable = [[HTCacheTable alloc] initWithName:NSStringFromClass(self) fields:nil cache:[HTCache standardCache]];

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
            [cacheTable addTableField:[self fieldTypeFromDataTypeClass:typeCls] name:propertyNameString attrs:[self attrsForField]];
        }
    }

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

+ (NSArray *)attrsForField {
    return @[];
}
@end