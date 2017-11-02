//
//  ImageViewerViewController.h
//  FunClub
//
//  Created by wang yang on 2017/11/2.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ImageViewerViewController : ASViewController
@property (assign, nonatomic) UIImage *image;
@property (assign, nonatomic) id<ASAnimatedImageProtocol> animatedImage;
@end
