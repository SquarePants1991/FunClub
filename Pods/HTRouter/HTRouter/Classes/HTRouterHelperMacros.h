//
//  HTRouterHelperMacros.h
//  Pods
//
//  Created by wangyang on 2016/9/28.
//
//

#ifndef HTRouterHelperMacros_h
#define HTRouterHelperMacros_h

#define HTRouterInitPageFromStoryboard(StoryboardName,StoryboardID) \
+ (instancetype)instantiateViewController {\
    return [[UIStoryboard storyboardWithName:StoryboardName bundle:[NSBundle bundleForClass:self]] instantiateViewControllerWithIdentifier:StoryboardID];\
}

#define HTRouterInitPage() \
+ (instancetype)instantiateViewController {\
    return [self new];\
}

#define HTRouterInitDialog(WidthPadding,Height) \
@synthesize completedBlock;\
- (CGSize)dialogSize {\
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - WidthPadding * 2, Height);\
}

#endif /* HTRouterHelperMacros_h */
