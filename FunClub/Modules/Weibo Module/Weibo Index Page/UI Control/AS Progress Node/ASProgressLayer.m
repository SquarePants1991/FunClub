//
// Created by wang yang on 2017/11/15.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import "ASProgressLayer.h"

@interface ASProgressLayer()
@property (strong, nonatomic) CALayer *barLayer;
@end

@implementation ASProgressLayer

- (CALayer *)barLayer {
    if (_barLayer == nil) {
        _barLayer = [CALayer layer];
        [self addSublayer:_barLayer];
        [_barLayer setFrame:CGRectZero];
    }
    return _barLayer;
}

- (void)setProgress:(CGFloat)progress {
    if (_barLayer.frame.size.height != self.bounds.size.height) {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        [self.barLayer setFrame: CGRectMake(0, 0, progress * self.bounds.size.width, self.bounds.size.height)];
        [CATransaction commit];
    } else {
        [self.barLayer setFrame: CGRectMake(0, 0, progress * self.bounds.size.width, self.bounds.size.height)];
    }
    _progress = progress;
}

- (void)setProgressBarColor:(UIColor *)progressBarColor {
    self.barLayer.backgroundColor = progressBarColor.CGColor;
}

@end