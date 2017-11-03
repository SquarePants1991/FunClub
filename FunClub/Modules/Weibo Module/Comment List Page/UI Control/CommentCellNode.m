//
// Created by wang yang on 2017/11/3.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import "CommentCellNode.h"

@interface CommentCellNode() {
    ASTextNode *_contentNode;
}
@end

@implementation CommentCellNode
- (instancetype)initWithViewModel:(CommentListItemViewModel *)viewModel
{
    self = [super init];
    if (self) {
        _contentNode = [ASTextNode new];
        _contentNode.attributedText = [[NSAttributedString alloc] initWithString:viewModel.content];
        [self addSubnode:_contentNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASInsetLayoutSpec *insetLayoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(13, 13, 13, 13) child:_contentNode];
    return insetLayoutSpec;
}
@end