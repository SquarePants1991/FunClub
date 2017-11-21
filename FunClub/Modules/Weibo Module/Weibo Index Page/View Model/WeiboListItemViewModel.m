//
//  WeiboListItemViewModel.m
//  FunClub
//
//  Created by yang wang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "WeiboListItemViewModel.h"

@implementation WeiboListItemViewModel
- (id)initWithModel:(WeiboListItemModel *)model {
    if (self = [super init]) {
        self.uid = [model.uid isKindOfClass:[NSNull class]] ? 0 : [model.uid integerValue];
        self.wid = [model.wid integerValue];
        [self setTime:[model.timestamp doubleValue]];
        [self setImageUrl:model.imageUrl];
        [self setImageWidth:[model.imageWidth integerValue] ];
        [self setImageHeight:[model.imageHeight integerValue]];
        [self setTitle:model.title];
        [self setLikesCount:[model.likesCount intValue]];
    }
    return self;
}

- (void)setTime:(NSTimeInterval)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.timeString = [dateFormatter stringFromDate:date];
    self.timestamp = timestamp;
}
@end
