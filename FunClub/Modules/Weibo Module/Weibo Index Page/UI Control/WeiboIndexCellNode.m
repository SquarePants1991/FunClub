//
//  TextTableNode.m
//  FunClub
//
//  Created by wang yang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "WeiboIndexCellNode.h"

@interface WeiboIndexCellNode() <ASNetworkImageNodeDelegate> {
    ASTextNode *_timeNode;
    ASTextNode *_titleNode;
    ASNetworkImageNode *_imageNode;
    ASTextNode * _likeCountNode;
    ASButtonNode * _likeButtonNode;
    ASButtonNode * _commentButtonNode;
    ASRatioLayoutSpec *_imageNodeSpec;
}

@end

@implementation WeiboIndexCellNode
- (instancetype)initWithViewModel:(WeiboListItemViewModel *)viewModel
{
    self = [super init];
    if (self) {
        _timeNode = [ASTextNode new];
        _timeNode.attributedText = [[NSAttributedString alloc] initWithString:viewModel.timeString];
        [self addSubnode:_timeNode];
        
        _titleNode = [ASTextNode new];
        _titleNode.attributedText = [[NSAttributedString alloc] initWithString:viewModel.title attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
        [self addSubnode:_titleNode];
        
        _imageNode = [ASNetworkImageNode new];
        [_imageNode setURL:[NSURL URLWithString:viewModel.imageUrl]];
        _imageNode.contentMode = UIViewContentModeScaleToFill;
        [self addSubnode:_imageNode];
        _imageNode.delegate = self;
        
        _likeCountNode = [ASTextNode new];
        _likeCountNode.attributedText = [[NSAttributedString alloc] initWithString:@"赞 (10)"];
        [self addSubnode:_likeCountNode];
        
        _likeButtonNode = [ASButtonNode new];
        [_likeButtonNode setTitle:@"点赞" withFont:nil withColor:nil forState:UIControlStateNormal];
        [self addSubnode:_likeButtonNode];
        
        _commentButtonNode = [ASButtonNode new];
        [_commentButtonNode setTitle:@"评论" withFont:nil withColor:nil forState:UIControlStateNormal];
        [self addSubnode:_commentButtonNode];
        
        [_commentButtonNode addTarget:self action:@selector(commentButtonTapped:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *buttonsLeftSpec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    [buttonsLeftSpec setChildren:@[_likeCountNode]];
    
    ASStackLayoutSpec *buttonsRightSpec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    [buttonsRightSpec setChildren:@[_likeButtonNode, _commentButtonNode]];
    
    ASStackLayoutSpec *buttonsSpec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    buttonsSpec.justifyContent = ASStackLayoutJustifyContentSpaceBetween;
    [buttonsSpec setChildren:@[buttonsLeftSpec, buttonsRightSpec]];
    
    float ratio = 1.0;
    if (_imageNode.image) {
        ratio = _imageNode.image.size.height / _imageNode.image.size.width;
    }
    ASRatioLayoutSpec *imageSpec = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:ratio child:_imageNode];
    
    ASStackLayoutSpec *verticalStack  = [ASStackLayoutSpec verticalStackLayoutSpec];
    verticalStack.spacing = 13;
    [verticalStack setChildren:@[ _timeNode, _titleNode, imageSpec, buttonsSpec]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(13, 13, 13, 13) child:verticalStack];
}

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}

- (void)commentButtonTapped:(id)sender {
    NSLog(@"Comment");
}
@end
