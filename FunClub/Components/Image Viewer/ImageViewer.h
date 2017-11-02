//
//  ImageViewer.h
//  FunClub
//
//  Created by wang yang on 2017/11/2.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ImageViewer : NSObject
+ (void)viewImage:(UIImage *)image;
+ (void)viewAnimatedImage:(id<ASAnimatedImageProtocol>)animatedImage;
@end
