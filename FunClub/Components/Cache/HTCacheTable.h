//
//  HTCacheTable.h
//  FunClub
//
//  Created by wang yang on 2017/11/17.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HTCacheTableFieldTypeInteger,
    HTCacheTableFieldTypeNumber,
    HTCacheTableFieldTypeText,
    HTCacheTableFieldTypeBlob,
} HTCacheTableFieldType;

typedef enum : NSUInteger {
    HTCacheTableFieldAttrIsPrimary,
    HTCacheTableFieldAttrIsPrimaryAutoInc
} HTCacheTableFieldAttr;

@class HTCache;

typedef void(^HTCacheTableBoolOperationHandler)(BOOL result);
typedef void(^HTCacheTableFetchListOperationHandler)(NSArray *result);

@interface HTCacheTableField: NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSArray *attrs;
@property (assign, nonatomic) HTCacheTableFieldType type;
- (id)initWithName:(NSString *)name type:(HTCacheTableFieldType)type attrs:(NSArray *)attrs;
+ (id)fieldWithName:(NSString *)name type:(HTCacheTableFieldType)type;
@end

@interface HTCacheTable : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSArray *fields;
@property (strong, nonatomic) HTCache *cache;
- (id)initWithName:(NSString *)name fields:(NSArray *)field cache:(HTCache *)cache;
- (void)addTableField:(HTCacheTableFieldType)type name:(NSString *)fieldName attrs:(NSArray *)attrs;
- (BOOL)create;
- (BOOL)drop;
- (void)isExistWithCompleted:(HTCacheTableBoolOperationHandler)resultHandler;
- (BOOL)insertValue:(NSArray *)values toFields:(NSArray *)fields;
- (BOOL)updateValue:(NSArray *)values toFields:(NSArray *)fields where:(NSArray *)conditions;
- (void)fetchValues:(int)skip limit:(int)limit fromFields:(NSArray *)fields completed:(HTCacheTableFetchListOperationHandler)resultHandler;
- (void)fetchValues:(int)skip limit:(int)limit fromFields:(NSArray *)fields sortedBy:(HTCacheTableField *)field isDesc:(BOOL)isDesc completed:(HTCacheTableFetchListOperationHandler)resultHandler;
- (void)fetchValues:(int)skip limit:(int)limit fromFields:(NSArray *)fields where:(NSArray *)conditions sortedBy:(HTCacheTableField *)sortField isDesc:(BOOL)isDesc completed:(HTCacheTableFetchListOperationHandler)resultHandler;
@end
