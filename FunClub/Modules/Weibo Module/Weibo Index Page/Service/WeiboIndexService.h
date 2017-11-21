//
//  WeiboIndexService.h
//  FunClub
//
//  Created by yang wang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@interface WeiboIndexService : NSObject
@property (assign, nonatomic) NSTimeInterval maxTimestamp;
@property (assign, nonatomic) int currentLoadPage;
@property (assign, nonatomic) float lastReadPoint;
- (RACSignal *)refreshWeiboList;
- (RACSignal *)restoreWeiboList;
- (RACSignal *)fetchWeiboList;
@end
