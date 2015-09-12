//
//  TPCTabBarController.m
//  礼物说
//
//  Created by tripleCC on 15/1/8.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPTabBarController.h"
#import "GPNavigationController.h"
#import "GPGiftViewController.h"
#import "TPCCategoryViewController.h"
#import "GPItemViewController.h"
#import "TPCUserViewController.h"

@interface GPTabBarController ()

@end

@implementation GPTabBarController

+ (void)initialize
{
    // 统一设置tabBarItem的字体颜色
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = TPCRGBColor(169, 183, 183);
    normalAttrs[NSFontAttributeName] = [UIFont fontWithName:TPCThemeFontName size:10.0];
    [tabBarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = TPCThemeColor;
    selectedAttrs[NSFontAttributeName] = [UIFont fontWithName:TPCThemeFontName size:10.0];
    [tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 添加子控制器
    [self setupChildControllers];
}

// 添加所有子控制器
- (void)setupChildControllers
{
    [self setupOneChildController:[[GPGiftViewController alloc] init] title:@"礼物说" image:[UIImage imageNamed:@"gift"] selectedImage:[UIImage imageNamed:@"gift-S"]];
    
    [self setupOneChildController:[[GPItemViewController alloc] init] title:@"单品" image:[UIImage imageNamed:@"item"] selectedImage:[UIImage imageNamed:@"item-S"]];
    
    [self setupOneChildControllerWithStoryboardName:@"TPCCategory" title:@"分类" image:[UIImage imageNamed:@"category"] selectedImage:[UIImage imageNamed:@"category-S"]];
    
    [self setupOneChildControllerWithStoryboardName:@"TPCUser" title:@"我" image:[UIImage imageNamed:@"user"] selectedImage:[UIImage imageNamed:@"user-S"]];
}

// 添加一个子控制器
- (void)setupOneChildController:(UIViewController *)vc title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    
    GPNavigationController *navVc = [[GPNavigationController alloc]  initWithRootViewController:vc];
    [self addChildViewController:navVc];
}

// 添加一个子控制器
- (void)setupOneChildControllerWithStoryboardName:(NSString *)name title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:name];
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;

    GPNavigationController *navVc = [[GPNavigationController alloc]  initWithRootViewController:vc];
    [self addChildViewController:navVc];
}
@end
