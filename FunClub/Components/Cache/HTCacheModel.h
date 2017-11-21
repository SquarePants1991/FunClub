//
// Created by wang yang on 2017/11/20.
// Copyright (c) 2017 ocean. All rights reserved.
//

// TODO: 如果主键是自增的，目前save完再save无效，后续解决

#import <Foundation/Foundation.h>
#import "HTCacheModelDataType.h"

#define HTCSetInteger(Src, Dst)\
if ([Src isKindOfClass:[NSNull class]]) {\
    self.Dst = nil;\
} else {\
    self.Dst = (HTCInteger *)(@([Src integerValue]));\
}

#define HTCSetText(Src, Dst)\
        self.Dst = (HTCText *)(Src);
#define HTCSetNumber(Src, Dst)\
        self.Dst = (HTCNumber *)(@([Src doubleValue]));

@class HTCacheTable;
@class HTCacheTableField;

typedef void(^HTCacheModelFetchCompleteHandler)(NSArray *models);

@protocol HTCacheModelProtocol
+ (NSArray *)attrsForField:(NSString *)fieldName;
+ (NSString *)primaryKey;
@end

@interface HTCacheModel : NSObject <HTCacheModelProtocol>

+ (HTCacheTable *)tableFromCacheModel;
- (void)save;
- (void)insert;
- (void)update;
+ (void)fetch:(int)skip limit:(int)limit where:(NSArray *)conditions sortedBy:(HTCacheTableField *)sortField isDesc:(BOOL)isDesc completed:(HTCacheModelFetchCompleteHandler)resultHandler;
+ (void)clearCache;
@end