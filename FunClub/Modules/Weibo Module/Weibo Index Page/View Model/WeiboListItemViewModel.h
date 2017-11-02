//
//  WeiboListItemViewModel.h
//  FunClub
//
//  Created by yang wang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboListItemViewModel : NSObject
@property (nonatomic, copy) NSString * timeString;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, assign) int likesCount;

- (void)setTime:(NSTimeInterval)timestamp;
@end
