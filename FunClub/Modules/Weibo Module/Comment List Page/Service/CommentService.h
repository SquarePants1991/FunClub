//
// Created by wang yang on 2017/11/3.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CommentService : NSObject
@property (assign, nonatomic) int currentLoadPage;
@property (assign, nonatomic) long long postID;
@property (assign, nonatomic) long long uid;
- (RACSignal *)refreshList;
- (RACSignal *)fetchList;
@end