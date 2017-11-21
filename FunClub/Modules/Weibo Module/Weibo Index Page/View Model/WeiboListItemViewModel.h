//
//  WeiboListItemViewModel.h
//  FunClub
//
//  Created by yang wang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboListItemModel.h"

@interface WeiboListItemViewModel : NSObject
@property (nonatomic, copy) NSString * timeString;
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, assign) int imageWidth;
@property (nonatomic, assign) int imageHeight;
@property (nonatomic, assign) int likesCount;
@property (nonatomic, assign) long long uid;
@property (nonatomic, assign) long long wid;

- (id)initWithModel:(WeiboListItemModel *)model;
- (void)setTime:(NSTimeInterval)timestamp;
@end
