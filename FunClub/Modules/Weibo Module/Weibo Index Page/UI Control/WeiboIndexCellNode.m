//
//  TextTableNode.m
//  FunClub
//
//  Created by wang yang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "WeiboIndexCellNode.h"
#import "ThemeManager.h"
#import "ImageViewer.h"
#import "DXRouter.h"
#import "ASProgressNode.h"

@interface WeiboIndexCellNode() <ASNetworkImageNodeDelegate> {
    ASTextNode *_timeNode;
    ASTextNode *_titleNode;
    ASNetworkImageNode *_imageNode;
    ASProgressNode *_imageProgressNode;
    ASTextNode *_likeCountNode;
    ASButtonNode *_likeButtonNode;
    ASButtonNode *_commentButtonNode;
    
    ASDisplayNode *_rootBgView;
    ASButtonNode *_seeCompleteImageButton;

    WeiboListItemViewModel *_viewModel;

    float _imageRatio;
}

@end

@implementation WeiboIndexCellNode
- (instancetype)initWithViewModel:(WeiboListItemViewModel *)viewModel
{
    self = [super init];
    if (self) {
        _viewModel = viewModel;

        _rootBgView = [ASDisplayNode new];
        _rootBgView.backgroundColor = Theme.lightBackgroundColor;
        _rootBgView.borderColor = Theme.borderColor.CGColor;
        _rootBgView.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        [self addSubnode:_rootBgView];
        
        _timeNode = [ASTextNode new];
        _timeNode.attributedText = [[NSAttributedString alloc] initWithString:viewModel.timeString attributes:@{NSFontAttributeName: Theme.smallFont, NSForegroundColorAttributeName: Theme.lightFontColor}];
        [self addSubnode:_timeNode];
        
        _titleNode = [ASTextNode new];
        _titleNode.attributedText = [[NSAttributedString alloc] initWithString:viewModel.title attributes:@{NSFontAttributeName: Theme.largeFont}];
        [self addSubnode:_titleNode];

        _imageNode = [ASNetworkImageNode new];
        _imageNode.backgroundColor = Theme.darkBackgroundColor;
        _imageNode.delegate = self;
        [_imageNode setURL:[NSURL URLWithString:viewModel.imageUrl]];
        _imageNode.contentMode = UIViewContentModeScaleToFill;
        [self addSubnode:_imageNode];
        [_imageNode addTarget:self action:@selector(imageTapped:) forControlEvents:ASControlNodeEventTouchUpInside];

        _imageProgressNode = [ASProgressNode new];
        _imageProgressNode.backgroundColor = Theme.darkBackgroundColor;
        _imageProgressNode.progressBarColor = [Theme.deepDarkBackgroundColor colorWithAlphaComponent:0.14];
        [self addSubnode:_imageProgressNode];


        _likeCountNode = [ASTextNode new];
        NSString *displayString = [NSString stringWithFormat:@"赞 (%d)", viewModel.likesCount];
        _likeCountNode.attributedText = [[NSAttributedString alloc] initWithString:displayString attributes:@{NSFontAttributeName: Theme.mediumFont, NSForegroundColorAttributeName: Theme.defaultFontColor}];
        [self addSubnode:_likeCountNode];
        
        _likeButtonNode = [ASButtonNode new];
        _likeButtonNode.style.minWidth = ASDimensionMake(60);
        _likeButtonNode.style.minHeight = ASDimensionMake(27);
        _likeButtonNode.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        _likeButtonNode.borderColor = Theme.borderColor.CGColor;
        _likeButtonNode.cornerRadius = 2.5;
        [_likeButtonNode setTitle:@"点赞" withFont:Theme.mediumFont withColor:Theme.defaultFontColor forState:UIControlStateNormal];
        [self addSubnode:_likeButtonNode];
        
        _commentButtonNode = [ASButtonNode new];
        _commentButtonNode.style.minWidth = ASDimensionMake(60);
        _commentButtonNode.style.minHeight = ASDimensionMake(27);
        _commentButtonNode.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        _commentButtonNode.borderColor = Theme.borderColor.CGColor;
        _commentButtonNode.cornerRadius = 2.5;
        [_commentButtonNode setTitle:@"评论" withFont:Theme.mediumFont withColor:Theme.defaultFontColor forState:UIControlStateNormal];
        [self addSubnode:_commentButtonNode];
        
        _seeCompleteImageButton = [ASButtonNode new];
        _seeCompleteImageButton.backgroundColor = Theme.darkMaskColor;
        _seeCompleteImageButton.style.minHeight = ASDimensionMake(37);
        [_seeCompleteImageButton setTitle:@"点击查看全图" withFont:Theme.mediumFont withColor:Theme.inverseFontColor forState:UIControlStateNormal];
        [self addSubnode:_seeCompleteImageButton];
        
        
        [_commentButtonNode addTarget:self action:@selector(commentButtonTapped:) forControlEvents:ASControlNodeEventTouchUpInside];


        _imageRatio = (float)(viewModel.imageHeight) / viewModel.imageWidth;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *buttonsLeftSpec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    [buttonsLeftSpec setChildren:@[_likeCountNode]];
    
    ASStackLayoutSpec *buttonsRightSpec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    buttonsRightSpec.spacing = 20;
    [buttonsRightSpec setChildren:@[_likeButtonNode, _commentButtonNode]];
    
    ASStackLayoutSpec *buttonsSpec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    buttonsSpec.justifyContent = ASStackLayoutJustifyContentSpaceBetween;
    buttonsSpec.alignItems = ASStackLayoutAlignItemsCenter;
    [buttonsSpec setChildren:@[buttonsLeftSpec, buttonsRightSpec]];

    
    ASLayoutSpec *imageSpec = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:_imageRatio child:_imageNode];
    if (_imageRatio > 2.0) {
        _imageRatio = 1.0;
        [(ASRatioLayoutSpec *)(imageSpec) setRatio:_imageRatio];
       _imageNode.contentMode = UIViewContentModeScaleAspectFill;

        ASInsetLayoutSpec *_newImageSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(INFINITY, 0, 0, 0) child:_seeCompleteImageButton];
        ASOverlayLayoutSpec *wrapperSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:imageSpec overlay:_newImageSpec];
        imageSpec = wrapperSpec;
    }

    ASOverlayLayoutSpec *progressOverlapSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:imageSpec overlay:_imageProgressNode];
    
    ASStackLayoutSpec *verticalStack  = [ASStackLayoutSpec verticalStackLayoutSpec];
    verticalStack.spacing = 13;
    [verticalStack setChildren:@[ _timeNode, _titleNode, progressOverlapSpec, buttonsSpec]];
    
    ASInsetLayoutSpec *insetContentSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(23, 23, 23, 23) child:verticalStack];
        ASInsetLayoutSpec *insetBgSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:_rootBgView];
    ASBackgroundLayoutSpec *backgroundSpec = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:insetContentSpec background:insetBgSpec];
    return backgroundSpec;
}

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
    if (imageNode.image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsLayout];
        });
    } else if (imageNode.animatedImage) {
        imageNode.animatedImage.coverImageReadyCallback = ^(UIImage * _Nonnull coverImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setNeedsLayout];
            });
        };
    }
    _imageProgressNode.hidden = YES;
}

- (void)imageNode:(ASNetworkImageNode *)imageNode progress:(CGFloat)progress {
    [_imageProgressNode setProgress:progress];
}

- (void)commentButtonTapped:(id)sender {
    [[DXRouter shared] navigateTo:@"CommentList" arguments:@{@"uid": @(_viewModel.uid), @"postID": @(_viewModel.wid)}];
}

- (void)imageTapped:(id)sender {
    if (_imageNode.image) {
        [ImageViewer viewImage:_imageNode.image];
    } else if (_imageNode.animatedImage) {
        [ImageViewer viewAnimatedImage:_imageNode.animatedImage];
    }
}
@end
