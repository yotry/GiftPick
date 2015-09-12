//
//  TPCNavigationController.m
//  礼物说
//
//  Created by tripleCC on 15/1/8.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPNavigationController.h"

@interface GPNavigationController ()

@end

@implementation GPNavigationController

+ (void)initialize
{
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    navigationBar.barTintColor = TPCThemeColor;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont fontWithName:TPCThemeFontName size:20.0];
    [navigationBar setTitleTextAttributes:attrs];
    
    // 返回图片和返回按钮颜色
    navigationBar.tintColor = [UIColor whiteColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
//        UIButton *btn = [[UIButton alloc] init];
//        [btn setTitle:@"返回" forState:UIControlStateNormal];
//        [btn setTitleColor:TPCThemeColor forState:UIControlStateHighlighted];
//        [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
//        [btn sizeToFit];
//        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
//        [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
} // 设置返回item

- (void)pop {
    [self popViewControllerAnimated:YES];
} // 返回方法


@end
