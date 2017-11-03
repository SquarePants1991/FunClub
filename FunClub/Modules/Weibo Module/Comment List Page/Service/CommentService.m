//
// Created by wang yang on 2017/11/3.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import "CommentService.h"
#import "CommentListItemViewModel.h"

const NSString * kCommentUrl = @"http://120.55.151.67/weibofun/comments_list.php?apiver=20100&fid=%lld&uid=%lld&category=weibo_pics&page=%d&page_size=%d&max_cid=-1&get_post=0&platform=iphone&appver=2.2.2&buildver=2020203&udid=F795A776-18F6-4FF9-AF3C-303DB0A3DC08&sysver=10.2.1&wf_uid=56743912";

#define PageSize 15

@implementation CommentService
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.postID = -1;
        self.currentLoadPage = 0;
    }
    return self;
}

- (RACSignal *)refreshList {
    RACReplaySubject * replaySubject = [RACReplaySubject subject];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kCommentUrl, self.postID, self.uid, 0, PageSize]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        if (error) {
            [replaySubject sendError:error];
            return;
        }
        NSMutableArray *viewModels = [self parseJsonToViewModels: data];
        self.currentLoadPage = 1;
        [replaySubject sendNext:viewModels];
        [replaySubject sendCompleted];
    }];
    [dataTask resume];

    return replaySubject;
}

- (RACSignal *)fetchList {
    RACReplaySubject * replaySubject = [RACReplaySubject subject];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kCommentUrl, self.postID, self.uid, self.currentLoadPage, PageSize]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        if (error) {
            [replaySubject sendError:error];
            return;
        }
        NSMutableArray *viewModels = [self parseJsonToViewModels: data];
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
        CommentListItemViewModel *viewModel = [CommentListItemViewModel new];
        [viewModel setContent:item[@"content"]];
        [viewModels addObject:viewModel];
    }
    return viewModels;
}
@end