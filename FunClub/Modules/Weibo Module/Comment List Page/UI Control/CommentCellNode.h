//
// Created by wang yang on 2017/11/3.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CommentListItemViewModel.h"

@interface CommentCellNode : ASCellNode
- (instancetype)initWithViewModel:(CommentListItemViewModel *)viewModel;
@end