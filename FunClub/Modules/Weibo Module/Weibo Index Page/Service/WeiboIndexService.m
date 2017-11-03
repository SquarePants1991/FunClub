//
//  WeiboIndexService.m
//  FunClub
//
//  Created by yang wang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "WeiboIndexService.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WeiboListItemViewModel.h"

#define PageSize 3

const NSString *kWeiboUrl = @"http://120.55.151.67/weibofun/weibo_list.php?apiver=20201&category=weibo_pics&page=%d&page_size=%d&max_timestamp=%lld&latest_viewed_ts=1490682600&platform=iphone&appver=2.2.2&buildver=2020203&udid=F795A776-18F6-4FF9-AF3C-303DB0A3DC08&sysver=10.2.1&wf_uid=56743912";

@implementation WeiboIndexService
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxTimestamp = -1;
        self.currentLoadPage = 0;
    }
    return self;
}

- (RACSignal *)refreshWeiboList {
    RACReplaySubject * replaySubject = [RACReplaySubject subject];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kWeiboUrl, 0, PageSize, -1]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        if (error) {
            [replaySubject sendError:error];
            return;
        }
        NSMutableArray *viewModels = [self parseJsonToViewModels: data];
        self.maxTimestamp = [(WeiboListItemViewModel *)[viewModels lastObject] timestamp];
        self.currentLoadPage = 1;
        [replaySubject sendNext:viewModels];
        [replaySubject sendCompleted];
    }];
    [dataTask resume];

    return replaySubject;
}

- (RACSignal *)fetchWeiboList {
    RACReplaySubject * replaySubject = [RACReplaySubject subject];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kWeiboUrl, self.currentLoadPage, PageSize, (long long)self.maxTimestamp]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        if (error) {
            [replaySubject sendError:error];
            return;
        }
        NSMutableArray *viewModels = [self parseJsonToViewModels: data];
        self.maxTimestamp = [(WeiboListItemViewModel *)[viewModels lastObject] timestamp];
        self.currentLoadPage++;
        [replaySubject sendNext:viewModels];
        [replaySubject sendCompleted];
    }];
    [dataTask resume];
    
    return replaySubject;
}

#pragma mark - Parse View Model
- (NSArray *)parseJsonToViewModels:(NSData *)jsonData {
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    NSArray *items = json[@"items"];
    NSMutableArray *viewModels = [NSMutableArray new];
    for (NSDictionary * item in items) {
        WeiboListItemViewModel *viewModel = [WeiboListItemViewModel new];

        [viewModel setTime: [item[@"update_time"] doubleValue]];
        [viewModel setImageUrl:item[@"wpic_large"]];
        [viewModel setTitle:item[@"wbody"]];
        if (![item[@"uid"] isKindOfClass:[NSNull class]]) {
            [viewModel setUid:[item[@"uid"] longLongValue]];
        }
        [viewModel setWid:([item[@"wid"] longLongValue])];
        [viewModel setLikesCount:(int)([item[@"likes"] doubleValue])];
        if ([item[@"w_sensitive"] intValue] == 0) {
            [viewModels addObject:viewModel];
        }
    }
    return viewModels;
}
@end
