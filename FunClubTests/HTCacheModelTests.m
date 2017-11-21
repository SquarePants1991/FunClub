#import <XCTest/XCTest.h>
#import "HTCache.h"
#import "HTCacheTable.h"
#import "HTCacheModel.h"

@interface PersonModel: HTCacheModel
@property (strong, nonatomic) HTCInteger *Id;
@property (strong, nonatomic) HTCText *name;
@property (strong, nonatomic) HTCInteger *sex; // 1 man 0 woman
@property (strong, nonatomic) HTCText *address;
@property (strong, nonatomic) HTCNumber *birthday;
@end

@implementation PersonModel
+ (NSString *)primaryKey {
    return @"Id";
}

+ (NSArray *)attrsForField:(NSString *)fieldName {
    if ([fieldName isEqualToString:@"Id"]) {
        return @[@(HTCacheTableFieldAttrIsPrimaryAutoInc)];
    }
    return @[];
}
@end

@interface HTCacheModelTests : XCTestCase {
}

@end

@implementation HTCacheModelTests
- (void)testTableFromCacheModel {
    HTCacheTable *table = [PersonModel tableFromCacheModel];
    XCTAssert([table fields].count == 5, @"PersonModel对应的table字段数目不正确");
}

- (void)testSaveModel {
    [PersonModel clearCache];
    PersonModel *ocean = [PersonModel new];
    ocean.sex = @1;
    ocean.name = @"wang yang";
    ocean.address = @"ShangHai University";
    ocean.birthday = @12330099;
    [ocean save];

    [PersonModel fetch:0 limit:10 where:nil sortedBy:nil isDesc:NO completed:^(NSArray *models) {
        XCTAssert(models.count == 1, "Model保存失败");
        PersonModel *personModel = models[0];
        XCTAssert([personModel.sex isEqualToNumber:@1], "Model数据保存不正确");
        XCTAssert([personModel.name isEqualToString:@"wang yang"], "Model数据保存不正确");
        XCTAssert([personModel.address isEqualToString:@"ShangHai University"], "Model数据保存不正确");
        XCTAssert([personModel.birthday isEqualToNumber:@12330099], "Model数据保存不正确");
    }];
}

- (void)testFetchModels {
    [PersonModel clearCache];
    PersonModel *ocean = [PersonModel new];
    ocean.sex = @1;
    ocean.name = @"wang yang";
    ocean.address = @"ShangHai University";
    ocean.birthday = @12330099;
    [ocean save];

    PersonModel *yuj = [PersonModel new];
    yuj.sex = @0;
    yuj.name = @"y jie";
    yuj.address = @"qd University";
    yuj.birthday = @12330099;
    [yuj save];

    [PersonModel fetch:0 limit:10 where:@[@"name == 'wang yang'"] sortedBy:nil isDesc:NO completed:^(NSArray *models) {
        XCTAssert(models.count == 1, "Model保存失败");
        PersonModel *personModel = models[0];
        XCTAssert([personModel.sex isEqualToNumber:@1], "Model数据保存不正确");
        XCTAssert([personModel.name isEqualToString:@"wang yang"], "Model数据保存不正确");
        XCTAssert([personModel.address isEqualToString:@"ShangHai University"], "Model数据保存不正确");
        XCTAssert([personModel.birthday isEqualToNumber:@12330099], "Model数据保存不正确");
    }];
}
@end