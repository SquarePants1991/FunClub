//
// Created by wang yang on 2017/11/20.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTCacheModelDataTypeProtocol
@end

@interface HTCInteger : NSNumber <HTCacheModelDataTypeProtocol>
@end

@interface HTCNumber : NSNumber <HTCacheModelDataTypeProtocol>
@end

@interface HTCText : NSString <HTCacheModelDataTypeProtocol>
@end

@interface HTCBlob : NSString <HTCacheModelDataTypeProtocol>
@end