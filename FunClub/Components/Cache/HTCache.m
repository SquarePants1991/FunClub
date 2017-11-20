//
// Created by wang yang on 2017/11/17.
// Copyright (c) 2017 ocean. All rights reserved.
//

#import "HTCache.h"
#import "HTCacheTable.h"

#import <FMDB/FMDB.h>

const NSString *kStandardCacheName = @"HTStandardCacheDatabase";

@interface HTCache() {
    FMDatabase *_database;
    NSString *_databasePath;
    BOOL _isDatabaseOpened;
}
@end

@implementation HTCache
+ (HTCache *)standardCache {
    static HTCache *_shared;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _shared = [[HTCache alloc] initWithName:(NSString *)kStandardCacheName];
    });
    return _shared;
}

- (id)initWithName:(NSString *)name {
    if (self = [super init]) {
        _databasePath = [self databasePathWithName: name];
        _database = [[FMDatabase alloc] initWithPath:_databasePath];
        _isDatabaseOpened = NO;
        [self open];
    }
    return self;
}

- (void)dealloc {
    [self close];
}

- (BOOL)isValid {
    return _database && _isDatabaseOpened;
}

#pragma mark - Database Basic Operations
- (void)open {
    if (_database) {
        _isDatabaseOpened = [_database open];
    }
}

- (void)close {
    if (_database) {
        _isDatabaseOpened = ![_database close];
    }
}

- (BOOL)executeSql:(NSString *)sql completed:(HTCacheExecuteSqlCompletedHandler)completed {
    return [_database executeStatements:sql withResultBlock:^int(NSDictionary *resultsDictionary) {
        if (completed) {
            completed(resultsDictionary);
        }
        return 0;
    }];
}

- (BOOL)executeQuery:(NSString *)sql completed:(HTCacheExecuteQueryCompletedHandler)completed {
    NSMutableArray *results = [NSMutableArray new];
    FMResultSet *fmResult = [_database executeQuery:sql];
    while ([fmResult next]) {
        [results addObject: [fmResult resultDictionary]];
    }
    if (completed) {
        completed([results copy]);
    }
    return YES;
}

#pragma mark - Utils
- (NSString *)databasePathWithName:(NSString *)name {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filepath = [NSString stringWithFormat:@"%@/%@.sqlit", documentPath, name];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        [[NSFileManager defaultManager] createFileAtPath:filepath contents:nil attributes:nil];
    }
    return filepath;
}
@end
