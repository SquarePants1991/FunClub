//
// Created by wang yang on 2017/11/3.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import "CommentListItemViewModel.h"


@implementation CommentListItemViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _nickname = @"Ocean";
        _avatarUrl = @"https://tower.im/assets/default_avatars/jokul.jpg";
    }
    return self;
}

- (NSString *)parseTimestampToString {
    NSString * resultString = nil;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeInterval delta = fabs([date timeIntervalSinceNow]);
    if (delta < 60) {
        // 时差小于60s
        resultString = @"刚刚";
    } else if (delta < 60 * 60) {
        resultString = [NSString stringWithFormat:@"%d分钟前", (int)(delta / 60)];
    } else if (delta < 60 * 60 * 24) {
        resultString = [NSString stringWithFormat:@"%d小时前", (int)(delta / 60 / 60)];
    } else if (delta < 60 * 60 * 24 * 365) {
        formatter.dateFormat = @"MM-dd HH:mm";
        resultString = [formatter stringFromDate:date];
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        resultString = [formatter stringFromDate:date];
    }
    return resultString;
}
@end