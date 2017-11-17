//
//  HTCacheTable.h
//  FunClub
//
//  Created by wang yang on 2017/11/17.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HTCacheTableFieldTypeNumber,
    HTCacheTableFieldTypeString,
    HTCacheTableFieldTypeText,
    HTCacheTableFieldTypeDate,
} HTCacheTableFieldType;

@interface HTCacheTable : NSObject
@property (copy, nonatomic) NSDictionary *fields;
@end
