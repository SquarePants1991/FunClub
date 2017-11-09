//
//  HTRouterUrlHandler.m
//  Pods
//
//  Created by wangyang on 2016/9/29.
//
//

#import "HTRouterUrlHandler.h"
#import "HTRouter.h"

@interface HTRouterUrlHandler ()

@property (strong, nonatomic) NSMutableDictionary *registeredUrls;

@end

@implementation HTRouterUrlHandler
+ (HTRouterUrlHandler *)shared {
    static HTRouterUrlHandler *_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [HTRouterUrlHandler new];
    });
    return _shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.registeredUrls = [NSMutableDictionary new];
    }
    return self;
}

- (void)registerUrl:(NSString *)url forRouters:(NSArray *)routers {
    [self.registeredUrls setObject:routers forKey:url];
}

- (void)handleUrl:(NSURL *)url {
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    NSString *host = components.host;
    NSMutableDictionary *arguments = [NSMutableDictionary new];
    for (NSURLQueryItem *item in components.queryItems) {
        arguments[item.name] = item.value;
    }
    NSArray *routers = self.registeredUrls[host];
    if (routers) {
        [[HTRouter shared] navigateWithArguments:arguments fullRouter:routers];
    }
}
@end
