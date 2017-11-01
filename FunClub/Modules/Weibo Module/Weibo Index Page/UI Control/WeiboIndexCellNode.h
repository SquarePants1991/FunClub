//
//  TextTableNode.h
//  FunClub
//
//  Created by wang yang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "WeiboListItemViewModel.h"

@interface WeiboIndexCellNode : ASCellNode
- (instancetype)initWithViewModel:(WeiboListItemViewModel *)viewModel;
@end
