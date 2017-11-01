//
//  ViewController.m
//  FunClub
//
//  Created by wang yang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "ViewController.h"
#import "TextTableNode.h"

@import AsyncDisplayKit;

@interface ViewController () <ASTableDelegate, ASTableDataSource> {
    ASTableNode *_tableNode;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableNode = [[ASTableNode alloc] init];
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    [self.view addSubnode:_tableNode];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableNode.frame = self.view.frame;
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextTableNode *node = [[TextTableNode alloc] initWithText:@"Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, Hello, "];
    return node;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < -200) {
        scrollView.contentOffset = CGPointMake(0, 0);
        [_tableNode reloadData];
    }
}

@end
