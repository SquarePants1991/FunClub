//
//  BaseFrameViewController.m
//  FunClub
//
//  Created by yang wang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "BaseFrameViewController.h"
#import "WeiboIndexViewController.h"
#import "DXRouter.h"

@interface BaseFrameViewController () <DXRouterViewControllerInstantiation>

@end

@implementation BaseFrameViewController

DXRouterInitPage()

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    self.title = @"Fun Club";
    [self createWeibo];
}

- (void)createWeibo {
    WeiboIndexViewController *vc = [WeiboIndexViewController new];
    vc.title = @"微博";
    [self addChildViewController:vc];
}

@end
