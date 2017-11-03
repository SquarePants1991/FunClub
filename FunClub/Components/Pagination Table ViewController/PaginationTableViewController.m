//
// Created by wang yang on 2017/11/3.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import "PaginationTableViewController.h"
#import "ThemeManager.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <MJRefresh/MJRefresh.h>

@interface PaginationTableViewController() <ASTableDelegate, ASTableDataSource>

@end

@implementation PaginationTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    _dataSource = [NSMutableArray new];

    _tableNode = [[ASTableNode alloc] init];
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    _tableNode.leadingScreensForBatching = 1.0;
    [self.view addSubnode:_tableNode];
    _tableNode.backgroundColor = Theme.darkBackgroundColor;
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;

    @weakify(_tableNode);
    _tableNode.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableNode.frame = self.view.frame;
}

#pragma mark - Table Delegate & DataSource
- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (BOOL)shouldBatchFetchForTableNode:(ASTableNode *)tableNode {
    return YES;
}

- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    [context beginBatchFetching];
    [self fetchMoreData:context];
}

#pragma mark - Data Process
- (void)fetchMoreData:(ASBatchContext *)context {

}

- (void)refreshData {

}
@end