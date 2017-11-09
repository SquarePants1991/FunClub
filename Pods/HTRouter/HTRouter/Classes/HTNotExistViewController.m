//
//  HTNotExistViewController.m
//  Pods
//
//  Created by wangyang on 2016/9/29.
//
//

#import "HTNotExistViewController.h"

@interface HTNotExistViewController ()

@end

@implementation HTNotExistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:self.view.bounds];
    label.text = @"404";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

@end
