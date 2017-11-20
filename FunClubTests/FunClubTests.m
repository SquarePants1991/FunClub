//
//  FunClubTests.m
//  FunClubTests
//
//  Created by wang yang on 2017/11/17.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HTCache.h"
#import "HTCacheTable.h"
#import "HTCacheModel.h"

@interface FunClubTests : XCTestCase {
    HTCache *_cache;
    HTCacheTable *_table;
}

@end

@implementation FunClubTests

- (void)setUp {
    [super setUp];
    _cache = [HTCache standardCache];

    HTCacheTableField *fieldID = [[HTCacheTableField alloc] initWithName:@"id" type:HTCacheTableFieldTypeInteger attrs:@[@(HTCacheTableFieldAttrIsPrimaryAutoInc)]];
    HTCacheTableField *fieldName = [HTCacheTableField fieldWithName:@"name" type:HTCacheTableFieldTypeText];
    HTCacheTableField *fieldContent = [HTCacheTableField fieldWithName:@"content" type:HTCacheTableFieldTypeText];
    _table = [[HTCacheTable alloc] initWithName:@"CacheTable" fields:@[fieldID, fieldName, fieldContent] cache:_cache];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCreateCache {
    XCTAssert([_cache isValid], @"HTCache open failed.");
}

- (void)testDropTable {
    [_table create];
    [_table drop];
    [_table isExistWithCompleted:^(BOOL result) {
        XCTAssert(!result, @"HTCache Table Drop Failed.");
    }];
}

- (void)testCreateTable {
    [_table drop];
    [_table create];
    [_table isExistWithCompleted:^(BOOL result) {
        XCTAssert(result, @"HTCache Table Exist Check Failed.");
    }];
}

- (void)testInsertData {
    [_table drop];
    [_table create];
    BOOL insertResult = [_table insertValue:@[@"ocean", @"content"] toFields:[_table.fields subarrayWithRange:NSMakeRange(1, 2)]];
    XCTAssert(insertResult, @"HTCache Table Insert Data Failed.");
}

- (void)testSelectData {
    [_table drop];
    [_table create];
    [_table insertValue:@[@"ocean", @"content"] toFields:[_table.fields subarrayWithRange:NSMakeRange(1, 2)]];
    [_table insertValue:@[@"ocean2", @"content2"] toFields:[_table.fields subarrayWithRange:NSMakeRange(1, 2)]];
    [_table fetchValues:0 limit:10 fromFields:_table.fields completed:^(NSArray *result) {
        XCTAssert(result.count == 2, "数据数目不正确");
        NSDictionary * firstResult = result[0];
        NSDictionary * secondResult = result[1];

        XCTAssert([firstResult allKeys].count == _table.fields.count, "结果与请求field数目不匹配");
        XCTAssert([firstResult[@"name"] isEqualToString:@"ocean"], "数据内容错误");
        XCTAssert([secondResult[@"name"] isEqualToString:@"ocean2"], "数据内容错误");
    }];

    [_table fetchValues:0 limit:10 fromFields:_table.fields sortedBy:_table.fields[0] isDesc:YES completed:^(NSArray *result) {
        XCTAssert(result.count == 2, "数据数目不正确");
        NSDictionary * firstResult = result[0];
        NSDictionary * secondResult = result[1];

        XCTAssert([firstResult allKeys].count == _table.fields.count, "结果与请求field数目不匹配");
        XCTAssert([firstResult[@"name"] isEqualToString:@"ocean2"], "数据内容错误");
        XCTAssert([secondResult[@"name"] isEqualToString:@"ocean"], "数据内容错误");
    }];

    [_table fetchValues:0 limit:10 fromFields:_table.fields where:@[@"id > 1"] sortedBy:_table.fields[0] isDesc:YES completed:^(NSArray *result) {
        XCTAssert(result.count == 1, "数据数目不正确");
        NSDictionary * firstResult = result[0];

        XCTAssert([firstResult allKeys].count == _table.fields.count, "结果与请求field数目不匹配");
        XCTAssert([firstResult[@"name"] isEqualToString:@"ocean2"], "数据内容错误");
    }];
}

- (void)testUpdateTable {
    [_table drop];
    [_table create];
    [_table insertValue:@[@"ocean", @"content"] toFields:[_table.fields subarrayWithRange:NSMakeRange(1, 2)]];
    [_table updateValue:@[@"ocean2", @"content2"] toFields:[_table.fields subarrayWithRange:NSMakeRange(1, 2)] where:@[@"name = 'ocean'"]];

    [_table fetchValues:0 limit:10 fromFields:_table.fields completed:^(NSArray *result) {
        XCTAssert(result.count == 1, "数据数目不正确");
        NSDictionary * firstResult = result[0];
        XCTAssert([firstResult[@"name"] isEqualToString:@"ocean2"], "数据内容错误");
    }];
}
@end
