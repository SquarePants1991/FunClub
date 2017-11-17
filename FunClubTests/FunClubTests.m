//
//  FunClubTests.m
//  FunClubTests
//
//  Created by wang yang on 2017/11/17.
//  Copyright © 2017年 ocean. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HTCache.h"

@interface FunClubTests : XCTestCase {
    HTCache *_cache;
}

@end

@implementation FunClubTests

- (void)setUp {
    [super setUp];
    _cache = [HTCache standardCache];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    XCTAssert([_cache isValid], @"HTCache open failed.");
}

@end
