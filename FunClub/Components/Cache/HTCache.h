//
// Created by wang yang on 2017/11/17.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HTCacheExecuteSqlCompletedHandler)(NSDictionary *resultSets);
typedef void(^HTCacheExecuteQueryCompletedHandler)(NSArray *resultSets);

@interface HTCache : NSObject
+ (HTCache *)standardCache;
- (id)initWithName:(NSString *)name;
/// 缓存机制是否工作正常
/// @return
- (BOOL)isValid;

- (BOOL)executeSql:(NSString *)sql completed:(HTCacheExecuteSqlCompletedHandler)completed;
- (BOOL)executeQuery:(NSString *)sql completed:(HTCacheExecuteQueryCompletedHandler)completed;
@end