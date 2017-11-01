//
//  BaseFrameViewController.m
//  FunClub
//
//  Created by yang wang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "BaseFrameViewController.h"
#import "WeiboIndexViewController.h"

@interface BaseFrameViewController ()

@end

@implementation BaseFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self createWeibo];
}

- (void)createWeibo {
    WeiboIndexViewController *vc = [WeiboIndexViewController new];
    vc.title = @"微博";
    [self addChildViewController:vc];
}

@end
