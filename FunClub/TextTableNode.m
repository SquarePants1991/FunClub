//
//  TextTableNode.m
//  FunClub
//
//  Created by wang yang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "TextTableNode.h"

@interface TextTableNode() {
    ASTextNode *_timeNode;
    ASTextNode *_titleNode;
    ASImageNode *_imageNode;
    ASTextNode * _likeCountNode;
    ASButtonNode * _likeButtonNode;
    ASButtonNode * _commentButtonNode;
}

@end

@implementation TextTableNode
- (instancetype)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        _timeNode = [ASTextNode new];
        _timeNode.attributedText = [[NSAttributedString alloc] initWithString:@"今天 11:20"];
        [self addSubnode:_timeNode];
        
        _titleNode = [ASTextNode new];
        _titleNode.attributedText = [[NSAttributedString alloc] initWithString:@"AsyncDisplayKit是一个非常棒的库"];
        [self addSubnode:_titleNode];
        
        _imageNode = [ASImageNode new];
        _imageNode.image = [UIImage imageNamed:@"avatar.jpg"];
        _imageNode.contentMode = UIViewContentModeScaleToFill;
        [self addSubnode:_imageNode];
        
        _likeCountNode = [ASTextNode new];
        _likeCountNode.attributedText = [[NSAttributedString alloc] initWithString:@"赞 (10)"];
        [self addSubnode:_likeCountNode];
        
        _likeButtonNode = [ASButtonNode new];
        [_likeButtonNode setTitle:@"点赞" withFont:nil withColor:nil forState:UIControlStateNormal];
        [self addSubnode:_likeButtonNode];
        
        _commentButtonNode = [ASButtonNode new];
        [_commentButtonNode setTitle:@"评论" withFont:nil withColor:nil forState:UIControlStateNormal];
        [self addSubnode:_commentButtonNode];
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
    
    ASStackLayoutSpec *verticalStack  = [ASStackLayoutSpec verticalStackLayoutSpec];
    verticalStack.spacing = 13;
    [verticalStack setChildren:@[ _timeNode, _titleNode, _imageNode, buttonsSpec]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(13, 13, 13, 13) child:verticalStack];
}
@end
