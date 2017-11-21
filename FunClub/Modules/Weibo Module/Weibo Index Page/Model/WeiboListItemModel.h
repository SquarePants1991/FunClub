//
// Created by wang yang on 2017/11/21.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCache.h"

@interface WeiboListItemModel : HTCacheModel
@property (nonatomic, strong) HTCInteger * uid;
@property (nonatomic, copy) HTCText * title;
@property (nonatomic, copy) HTCText * imageUrl;
@property (nonatomic, strong) HTCInteger * imageHeight;
@property (nonatomic, strong) HTCInteger * imageWidth;
@property (nonatomic, strong) HTCNumber * timestamp;
@property (nonatomic, strong) HTCInteger * likesCount;
@property (nonatomic, strong) HTCInteger * wid;

- (id)initWithDictionary:(NSDictionary *)dic;
@end