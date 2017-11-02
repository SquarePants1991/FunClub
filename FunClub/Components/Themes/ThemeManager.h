//
//  ThemeManager.h
//  FunClub
//
//  Created by wang yang on 2017/11/2.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Theme [ThemeManager shared]

@interface ThemeManager : NSObject
+ (ThemeManager *)shared;
@property (strong, nonatomic) UIColor *inverseFontColor;
@property (strong, nonatomic) UIColor *defaultFontColor;
@property (strong, nonatomic) UIColor *darkFontColor;
@property (strong, nonatomic) UIColor *lightFontColor;
@property (strong, nonatomic) UIFont *defaultFont;
@property (strong, nonatomic) UIFont *largeFont;
@property (strong, nonatomic) UIFont *mediumFont;
@property (strong, nonatomic) UIFont *smallFont;

@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIColor *lightBackgroundColor;
@property (strong, nonatomic) UIColor *darkBackgroundColor;
@property (strong, nonatomic) UIColor *darkMaskColor;
@end
