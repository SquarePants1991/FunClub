//
//  WeiboIndexViewController.m
//  FunClub
//
//  Created by yang wang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "WeiboIndexViewController.h"
#import "WeiboIndexCellNode.h"
#import "WeiboIndexService.h"
#import "ThemeManager.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface WeiboIndexViewController () <ASTableDelegate, ASTableDataSource> {
    NSMutableArray * _dataSource;
    ASTableNode *_tableNode;
    WeiboIndexService *_service;
}

@end

@implementation WeiboIndexViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray new];
    _service = [WeiboIndexService new];
    
    _tableNode = [[ASTableNode alloc] init];
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    _tableNode.leadingScreensForBatching = 1.0;
    [self.view addSubnode:_tableNode];
    _tableNode.backgroundColor = Theme.darkBackgroundColor;
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableNode.frame = self.view.frame;
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboListItemViewModel *viewModel = _dataSource[indexPath.row];
    return ^{
        WeiboIndexCellNode *node = [[WeiboIndexCellNode alloc] initWithViewModel:viewModel];
        return node;
    };
}

- (BOOL)shouldBatchFetchForTableNode:(ASTableNode *)tableNode {
    return YES;
}

- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    [context beginBatchFetching];
    [self fetchMoreData:context];
}

#pragma mark - Fake Data
- (void)fetchMoreData:(ASBatchContext *)context {
    [[_service fetchWeiboList] subscribeNext:^(NSArray * items) {
        [_dataSource addObjectsFromArray:items];
        NSMutableArray *paths = [NSMutableArray new];
        for (int i = (int)items.count; i > 0; --i) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSource.count - i inSection:0];
            [paths addObject:indexPath];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableNode insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
            [context completeBatchFetching:YES];
        });
    } error:^(NSError *error) {
        
    }];
}
@end
