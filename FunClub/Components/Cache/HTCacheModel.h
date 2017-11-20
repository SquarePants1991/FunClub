//
// Created by wang yang on 2017/11/20.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCacheModelDataType.h"

@class HTCacheTable;

@interface HTCacheModel : NSObject

+ (HTCacheTable *)tableFromCacheModel;
- (void)insert;
@end