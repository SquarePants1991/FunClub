//
// Created by wang yang on 2017/11/15.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>


@interface ASProgressNode : ASDisplayNode
@property (strong, nonatomic) UIColor *progressBarColor;
@property (assign, nonatomic) CGFloat progress;
@end