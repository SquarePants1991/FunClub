//
// Created by wang yang on 2017/11/3.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import "PaginationTableViewController.h"
#import "ThemeManager.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <MJRefresh/MJRefresh.h>

@interface PaginationTableViewController() <ASTableDelegate, ASTableDataSource>
@property (assign, nonatomic) BOOL isLoaded;
@end

@implementation PaginationTableViewController

- (instancetype)init
{
    _tableNode = [[ASTableNode alloc] init];
    self = [super initWithNode:_tableNode];

    if (self) {
        _isLoaded = NO;
        _tableNode.dataSource = self;
        _tableNode.delegate = self;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataSource = [NSMutableArray new];

    _tableNode.leadingScreensForBatching = 1.0;

    [self.view addSubnode:_tableNode];
    _tableNode.backgroundColor = Theme.darkBackgroundColor;
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;

    @weakify(_tableNode);
    _tableNode.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}

#pragma mark - Table Delegate & DataSource

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    if (self.isLoaded) {
        [context beginBatchFetching];
        [self fetchMoreData:context];
    } else {
        [context beginBatchFetching];
        [context completeBatchFetching:YES];
    }
}

#pragma mark - Data Process
- (void)refreshData {
    @weakify(self);
    [self refreshDataWithComplete:^(BOOL isSuccess) {
        @strongify(self);
        if (isSuccess) {
            self.isLoaded = YES;
        }
    }];
}

- (void)fetchMoreData:(ASBatchContext *)context {

}

- (void)refreshDataWithComplete:(RefreshCompleteHandler)completed {

}


@end