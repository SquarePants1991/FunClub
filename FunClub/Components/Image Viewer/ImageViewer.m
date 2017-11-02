//
//  ImageViewer.m
//  FunClub
//
//  Created by wang yang on 2017/11/2.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "ImageViewer.h"
#import "ImageViewerViewController.h"

@implementation ImageViewer
+ (void)viewImage:(UIImage *)image {
    ImageViewerViewController *vc = [ImageViewerViewController new];
    vc.image = image;
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)rootVC pushViewController:vc animated:YES];
    } else {
        [rootVC presentViewController:vc animated:YES completion:^{
            
        }];
    }
}

+ (void)viewAnimatedImage:(id<ASAnimatedImageProtocol>)animatedImage {
    ImageViewerViewController *vc = [ImageViewerViewController new];
    vc.animatedImage = animatedImage;
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)rootVC pushViewController:vc animated:YES];
    } else {
        [rootVC presentViewController:vc animated:YES completion:^{
            
        }];
    }
}
@end
