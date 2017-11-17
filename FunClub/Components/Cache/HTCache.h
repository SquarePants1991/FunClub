//
// Created by wang yang on 2017/11/17.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTCache : NSObject
+ (HTCache *)standardCache;
- (id)initWithName:(NSString *)name;
/// 缓存机制是否工作正常
/// @return
- (BOOL)isValid;
@end