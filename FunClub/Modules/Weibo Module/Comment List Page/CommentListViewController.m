//
// Created by wang yang on 2017/11/3.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentListItemViewModel.h"
#import "CommentService.h"
#import "CommentCellNode.h"

#import "DXRouter.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <MJRefresh/MJRefresh.h>

@interface CommentListViewController () <DXRouterViewControllerInstantiation> {
    CommentService *_service;
}

@end

@implementation CommentListViewController

DXRouterInitPage()


- (void)loadView {
    _service = [CommentService new];
    _service.postID = self.postID;
    _service.uid = self.uid;

    [super loadView];

    [self.tableNode setAllowsSelection:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentListItemViewModel *viewModel = self.dataSource[indexPath.row];
    return ^{
        CommentCellNode *node = [[CommentCellNode alloc] initWithViewModel:viewModel];
        return node;
    };
}

#pragma mark - Data Process
- (void)fetchMoreData:(ASBatchContext *)context {
    [[_service fetchList] subscribeNext:^(NSArray * items) {
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
    [[_service refreshList] subscribeNext:^(id x) {
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
@end