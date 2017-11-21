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

#import "DXRouter.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <MJRefresh/MJRefresh.h>

@interface WeiboIndexViewController () <DXRouterViewControllerInstantiation> {
    WeiboIndexService *_service;
    NSTimer * _readPointRecordTimer;
}

@end

@implementation WeiboIndexViewController

DXRouterInitPage()

- (void)loadView {
    _service = [WeiboIndexService new];
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    _readPointRecordTimer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer *timer) {
        [_service setLastReadPoint:self.tableNode.contentOffset.y];
    }];
    [[NSRunLoop mainRunLoop] addTimer:_readPointRecordTimer forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_readPointRecordTimer invalidate];
    _readPointRecordTimer = nil;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboListItemViewModel *viewModel = [[WeiboListItemViewModel alloc] initWithModel: self.dataSource[indexPath.row]];
    return ^{
        WeiboIndexCellNode *node = [[WeiboIndexCellNode alloc] initWithViewModel:viewModel];
        return node;
    };
}

#pragma mark - Data Process
- (void)fetchMoreData:(ASBatchContext *)context {
    [[_service fetchWeiboList] subscribeNext:^(NSArray * items) {
        [self.dataSource addObjectsFromArray:items];
        NSMutableArray *paths = [NSMutableArray new];
        for (int i = (int)items.count; i > 0; --i) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - i inSection:0];
            [paths addObject:indexPath];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableNode insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
            if (context) {
                [context completeBatchFetching:YES];
            }
        });
    } error:^(NSError *error) {
        
    }];
}

- (void)refreshDataWithComplete:(RefreshCompleteHandler)completed {
    @weakify(self);
    [[_service refreshWeiboList] subscribeNext:^(id x) {
        @strongify(self);
        self.dataSource = x;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableNode reloadData];
            [self.tableNode.view.mj_header endRefreshing];
            completed(YES);
        });
    } error:^(NSError *error) {
        completed(NO);
    }];
}

- (void)restoreDataWithComplete:(RefreshCompleteHandler)completed {
    @weakify(self);
    [[_service restoreWeiboList] subscribeNext:^(id x) {
        @strongify(self);
        self.dataSource = x;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableNode reloadData];
            [self.tableNode setContentOffset:CGPointMake(0, _service.lastReadPoint)];
            [self.tableNode.view.mj_header endRefreshing];
            completed(YES);
        });
    } error:^(NSError *error) {
        completed(NO);
    }];
}

- (BOOL)canRestore {
    return _service.lastReadPoint > 0;
}
@end
