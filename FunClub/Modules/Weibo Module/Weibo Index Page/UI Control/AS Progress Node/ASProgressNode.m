//
// Created by wang yang on 2017/11/15.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import "ASProgressNode.h"
#import "ASProgressLayer.h"

@interface ASProgressNode()
@property (strong, nonatomic) ASProgressLayer *progressLayer;
@end

@implementation ASProgressNode

- (instancetype)init {
    if (self = [super init]) {
        [self setLayerBlock:^CALayer * {
            return self.progressLayer;
        }];
    }
    return self;
}

- (ASProgressLayer *)progressLayer {
    if (_progressLayer == nil) {
        _progressLayer = [ASProgressLayer layer];
        _progressLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _progressLayer;
}

- (void)setProgress:(CGFloat)progress {
    [self.progressLayer setProgress:progress];
}

- (void)setProgressBarColor:(UIColor *)progressBarColor {
    [self.progressLayer setProgressBarColor:progressBarColor];
}
@end