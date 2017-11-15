//
// Created by wang yang on 2017/11/3.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CommentCellNode.h"
#import "ThemeManager.h"

@interface CommentCellNode() {
    ASTextNode *_nicknameNode;
    ASTextNode *_likesNode;
    ASTextNode *_timeNode;
    ASTextNode *_contentNode;
    ASNetworkImageNode *_networkImageNode;

    ASDisplayNode * _contentBgNode;
    ASDisplayNode * _sideBorderNode;
}
@end

@implementation CommentCellNode
- (instancetype)initWithViewModel:(CommentListItemViewModel *)viewModel
{
    self = [super init];
    if (self) {
        _sideBorderNode = [ASDisplayNode new];
        _sideBorderNode.backgroundColor = Theme.borderColor;
        _sideBorderNode.style.maxWidth = ASDimensionMake(1 / [UIScreen mainScreen].scale);
        [self addSubnode:_sideBorderNode];

        _contentBgNode = [ASDisplayNode new];
        _contentBgNode.borderColor = [Theme.borderColor CGColor];
        _contentBgNode.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        _contentBgNode.backgroundColor = Theme.lightBackgroundColor;
        [self addSubnode:_contentBgNode];

        _timeNode = [ASTextNode new];
        _timeNode.attributedText = [[NSAttributedString alloc] initWithString:viewModel.timestampString attributes:@{NSFontAttributeName: Theme.exsmallFont, NSForegroundColorAttributeName: Theme.lightFontColor}];
        [self addSubnode:_timeNode];

        _contentNode = [ASTextNode new];
        _contentNode.attributedText = [[NSAttributedString alloc] initWithString:viewModel.content attributes:@{NSFontAttributeName: Theme.mediumFont, NSForegroundColorAttributeName: Theme.defaultFontColor}];
        [self addSubnode:_contentNode];

        _nicknameNode = [ASTextNode new];
        _nicknameNode.attributedText = [[NSAttributedString alloc] initWithString:viewModel.nickname attributes:@{NSFontAttributeName: Theme.smallFont, NSForegroundColorAttributeName: Theme.nicknameFontColor}];
        [self addSubnode:_nicknameNode];

        _likesNode = [ASTextNode new];
        _likesNode.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"赞（%d）", viewModel.likes] attributes:@{NSFontAttributeName: Theme.smallFont, NSForegroundColorAttributeName: Theme.lightFontColor}];
        [self addSubnode:_likesNode];

        _networkImageNode = [ASNetworkImageNode new];
        _networkImageNode.backgroundColor = Theme.lightBackgroundColor;
        _networkImageNode.cornerRadius = 15;
        _networkImageNode.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        _networkImageNode.borderColor = Theme.borderColor.CGColor;
        _networkImageNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(30.0), ASDimensionMake(30.0));
        [_networkImageNode setURL:[[NSURL alloc] initWithString:viewModel.avatarUrl]];
        [self addSubnode:_networkImageNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *verticalStackSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    verticalStackSpec.spacing = 10;

    ASStackLayoutSpec *horizontalStackSpec = [ASStackLayoutSpec horizontalStackLayoutSpec];
    horizontalStackSpec.children = @[_nicknameNode, _likesNode];
    horizontalStackSpec.justifyContent = ASStackLayoutJustifyContentSpaceBetween;

    [verticalStackSpec setChildren:@[horizontalStackSpec, _timeNode, _contentNode]];

    ASInsetLayoutSpec *insetVerticalLayoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 15, 10, 10) child:verticalStackSpec];

    ASBackgroundLayoutSpec * contentBGSpec = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:insetVerticalLayoutSpec background:_contentBgNode];

    ASRelativeLayoutSpec *_avatarSpec = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionStart verticalPosition:ASRelativeLayoutSpecPositionStart sizingOption:ASRelativeLayoutSpecSizingOptionMinimumSize child:_networkImageNode];
    ASInsetLayoutSpec *_avatarInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(-15, -15, 0, INFINITY) child:_avatarSpec];


    ASWrapperLayoutSpec *container = [ASWrapperLayoutSpec wrapperWithLayoutElements:@[contentBGSpec, _avatarInsetSpec]];

    ASInsetLayoutSpec *insetLayoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(26, 25, 0, 10) child:container];
    ASInsetLayoutSpec *_leftBorderSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 25, 0, INFINITY) child:_sideBorderNode];
    return [ASOverlayLayoutSpec overlayLayoutSpecWithChild:insetLayoutSpec overlay:_leftBorderSpec];
}
@end