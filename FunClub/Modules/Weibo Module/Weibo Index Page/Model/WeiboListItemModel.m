//
// Created by wang yang on 2017/11/21.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import "WeiboListItemModel.h"


@implementation WeiboListItemModel
+ (NSString *)primaryKey {
    return @"wid";
}

+ (NSArray *)attrsForField:(NSString *)fieldName {
    if ([fieldName isEqualToString:@"wid"]) {
        return @[@(HTCacheTableFieldAttrIsPrimary)];
    }
    return @[];
}

- (id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        HTCSetInteger(dic[@"uid"], uid);
        HTCSetNumber(dic[@"update_time"], timestamp);
        HTCSetText(dic[@"wpic_middle"], imageUrl);
        HTCSetInteger(dic[@"wpic_m_width"], imageWidth);
        HTCSetInteger(dic[@"wpic_m_height"], imageHeight);
        HTCSetText(dic[@"wbody"], title);
        HTCSetInteger(dic[@"wid"], wid);
        HTCSetInteger(dic[@"likes"], likesCount);
    }
    return self;
}
@end
