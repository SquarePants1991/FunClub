//
// Created by wang yang on 2017/11/3.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

typedef void(^RefreshCompleteHandler)(BOOL isSuccess);

@interface PaginationTableViewController : ASViewController
@property  (strong) NSMutableArray *dataSource;
@property  (strong) ASTableNode *tableNode;

- (void)fetchMoreData:(ASBatchContext *)context;
- (void)refreshData;
- (void)restoreData;
- (BOOL)canRestore;
@end