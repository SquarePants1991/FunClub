//
// Created by wang yang on 2017/11/3.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommentListItemViewModel : NSObject
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * avatarUrl;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, assign) int likes;
@property (nonatomic, assign) double timestamp;

@property (nonatomic, copy, getter=parseTimestampToString) NSString * timestampString;
@end