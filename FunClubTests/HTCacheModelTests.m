#import <XCTest/XCTest.h>
#import "HTCache.h"
#import "HTCacheTable.h"
#import "HTCacheModel.h"

@interface PersonModel: HTCacheModel
@property (strong, nonatomic) HTCText *name;
@property (strong, nonatomic) HTCInteger *sex; // 1 man 0 woman
@property (strong, nonatomic) HTCText *address;
@property (strong, nonatomic) HTCNumber *birthday;
@end

@implementation PersonModel
@end

@interface HTCacheModelTests : XCTestCase {
}

@end

@implementation HTCacheModelTests
- (void)testTableFromCacheModel {
    HTCacheTable *table = [PersonModel tableFromCacheModel];
    XCTAssert([table fields].count == 4, @"PersonModel对应的table字段数目不正确");
    [table create];
}

- (void)testInsertData {
    HTCacheTable *table = [PersonModel tableFromCacheModel];
    [table create];
}
@end