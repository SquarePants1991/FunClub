//
//  ImageViewerViewController.m
//  FunClub
//
//  Created by wang yang on 2017/11/2.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "ImageViewerViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ImageViewerViewController () {
    ASImageNode *_imageNode;
    ASScrollNode *_scrollNode;
}
@end

@implementation ImageViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    _imageNode = [ASImageNode new];
    _imageNode.image = self.image;
    _imageNode.animatedImage = self.animatedImage;
    _imageNode.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubnode:_imageNode];
    
    _scrollNode = [ASScrollNode new];
    _scrollNode.automaticallyManagesSubnodes = YES;
    _scrollNode.automaticallyManagesContentSize = YES;
    [self.view addSubnode:_scrollNode];
    @weakify(self, _imageNode);
    _scrollNode.layoutSpecBlock = ^(ASDisplayNode *node, ASSizeRange constrainedSize){
        @strongify(self, _imageNode);
        float ratio = 1.0;
        if (self.image) {
            ratio = self.image.size.height / self.image.size.width;
        } else if (self.animatedImage) {
            ratio = self.animatedImage.coverImage.size.height / self.animatedImage.coverImage.size.width;
        }
        ASRatioLayoutSpec *ratioSpec = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:ratio child:_imageNode];
        ASCenterLayoutSpec *centerSpec = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:ratioSpec];
        return centerSpec;
    };
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _scrollNode.frame = self.view.frame;
}

@end
