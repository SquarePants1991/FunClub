//
//  WeiboIndexService.m
//  FunClub
//
//  Created by yang wang on 2017/11/1.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import "WeiboIndexService.h"
#import "WeiboListItemModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#define PageSize 15

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
        [WeiboListItemModel clearCache];
        NSMutableArray *models = [self parseJsonToModels:data];
        self.maxTimestamp = [[(WeiboListItemModel *)[models lastObject] timestamp] doubleValue];
        self.currentLoadPage = 1;
        [replaySubject sendNext:models];
        [replaySubject sendCompleted];
    }];
    [dataTask resume];

    return replaySubject;
}

- (RACSignal *)restoreWeiboList {
    RACReplaySubject * replaySubject = [RACReplaySubject subject];
    [WeiboListItemModel fetch:0 limit:INT_MAX where:nil sortedBy:[HTCacheTableField fieldWithName:@"timestamp" type:HTCacheTableFieldTypeInteger] isDesc:YES completed:^(NSArray *models) {
        self.maxTimestamp = [[(WeiboListItemModel *)[models lastObject] timestamp] doubleValue];
        self.currentLoadPage = 1;
        [replaySubject sendNext:models];
        [replaySubject sendCompleted];
    }];
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
        NSMutableArray *models = [self parseJsonToModels:data];
        self.maxTimestamp = [[(WeiboListItemModel *)[models lastObject] timestamp] doubleValue];
        self.currentLoadPage++;
        [replaySubject sendNext:models];
        [replaySubject sendCompleted];
    }];
    [dataTask resume];
    
    return replaySubject;
}

#pragma mark - Parse Model
- (NSArray *)parseJsonToModels:(NSData *)jsonData {
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    NSArray *items = json[@"items"];
    NSMutableArray *models = [NSMutableArray new];
    for (NSDictionary * item in items) {
        WeiboListItemModel *model = [[WeiboListItemModel alloc] initWithDictionary:item];
        [models addObject:model];
    }
    [self saveModels:models];
    return models;
}

- (void)saveModels:(NSArray *)models {
    for (WeiboListItemModel *model in models) {
        [model save];
    }
}

#pragma mark - Read Point
- (void)setLastReadPoint:(float)lastReadPoint {
    [[NSUserDefaults standardUserDefaults] setObject:@(lastReadPoint) forKey:@"kLastReadPoint"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (float)lastReadPoint {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"kLastReadPoint"] floatValue];
}
@end
