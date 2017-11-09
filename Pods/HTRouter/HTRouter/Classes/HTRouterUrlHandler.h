//
//  HTRouterUrlHandler.h
//  Pods
//
//  Created by wangyang on 2016/9/29.
//
//

#import <Foundation/Foundation.h>

@interface HTRouterUrlHandler : NSObject
+ (HTRouterUrlHandler *)shared;

- (void)registerUrl:(NSString *)url forRouters:(NSArray *)routers;
- (void)handleUrl:(NSURL *)url;
@end
