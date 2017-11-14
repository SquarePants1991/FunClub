//
//  ThemeManager.m
//  FunClub
//
//  Created by wang yang on 2017/11/2.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager
+ (ThemeManager *)shared {
    static ThemeManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [ThemeManager new];
    });
    return _shared;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.inverseFontColor = [UIColor colorWithWhite:1 alpha:1.0];
        self.nicknameFontColor = [UIColor colorWithRed:0x17 / 255.0 green:0x70 / 255.0 blue:0xb7 / 255.0 alpha:1.0];
        self.defaultFontColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        self.darkFontColor = [UIColor colorWithWhite:0.0 alpha:1.0];
        self.lightFontColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        self.defaultFont = [UIFont systemFontOfSize:16];
        self.largeFont = [UIFont systemFontOfSize:18];
        self.mediumFont = [UIFont systemFontOfSize:14];
        self.smallFont = [UIFont systemFontOfSize:12];
        self.exsmallFont = [UIFont systemFontOfSize:10];
        self.borderColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        self.lightBackgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
        self.darkBackgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        self.deepDarkBackgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        self.darkMaskColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    }
    return self;
}
@end
