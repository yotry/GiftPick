//
//  TPCGuideTool.m
//  礼物说
//
//  Created by tripleCC on 15/1/8.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPGuideTool.h"
#import "GPTabBarController.h"
#import "TPCNewFeatrueViewController.h"
#import "GPSaveTool.h"

@implementation GPGuideTool
+ (UIViewController *)chooseRootViewController
{
    NSString *key = @"version";
    
    // 获取当前版本号
    NSString *curVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    // 获取上一个版本号
    NSString *preVersion = [GPSaveTool objectForKey:key];
    
    // 存储当前版本号
    [GPSaveTool setObject:curVersion forKey:key];
    
    UIViewController *viewController = nil;
    
    // 根据版本号是否相等，来进行界面的跳转
    if (![curVersion isEqualToString:preVersion]) {
        viewController = [[TPCNewFeatrueViewController alloc] init];
    } else {
        viewController = [[GPTabBarController alloc] init];;
    }
    
    return viewController;
}
@end
