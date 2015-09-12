//
//  TPCChoicenessTableHeaderView.m
//  礼物说
//
//  Created by tripleCC on 15/1/12.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPChoicenessHeaderView.h"
#import "GPVerticalButton.h"
#import "GPPageScrollView.h"
#import "GPBanner.h"
#import "GPBannerTarget.h"
#import "GPPromotion.h"
#import "GPGoodLittleThingViewController.h"
#import "GPSignViewController.h"
#import "GPBrandViewController.h"
#import "GPDailyLuckyViewController.h"
#import "GPWebViewController.h"

@interface GPChoicenessHeaderView() <GPPageScrollViewDelegate>

@property (weak, nonatomic) IBOutlet GPPageScrollView *pageScrollView;

@property (weak, nonatomic) IBOutlet UIView *buttonsSuperview;

/** 横幅数据 */
@property (strong, nonatomic) NSArray *banners;

/** 按钮数据 */
@property (strong, nonatomic) NSArray *promotions;

@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation GPChoicenessHeaderView
#pragma mark 懒加载
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
}
- (void)setBanners:(NSArray *)banners
{
    _banners = banners;
    
    [self setupPageScrollView];
}

- (void)setPromotions:(NSArray *)promotions
{
    _promotions = promotions;
    
    [self setupIconButtons];
}


#pragma mark 初始化
+ (instancetype)header
{
    GPChoicenessHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    headerView.pageScrollView.pageControlPostion = TPCPageControlPositionBottomCenter;
    headerView.pageScrollView.delegate = headerView;
    
    [headerView getBannersData];
    [headerView getPromotionsData];
    
    return headerView;
}
- (void)setupPageScrollView
{
    NSArray *imageURLStrings = [self.banners valueForKey:@"image_url"];
    self.pageScrollView.imageURLStrings = imageURLStrings;
    // 启动轮切
    [self.pageScrollView startAutoPagingWithDuration:8.0];
}

- (void)setupIconButtons
{
    [self.buttonsSuperview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat btnW = self.buttonsSuperview.gp_width / self.promotions.count;
    CGFloat btnH = self.buttonsSuperview.gp_height;
    
    for (NSInteger i = 0; i < self.promotions.count; i++) {
        GPVerticalButton *btn = [GPVerticalButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnW * i, 0, btnW, btnH);
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.buttonsSuperview addSubview:btn];
        
        GPPromotion *promotion = self.promotions[i];
        [btn addTarget:self action:@selector(iconButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn sd_setImageWithURL:[NSURL URLWithString:promotion.icon_url] forState:UIControlStateNormal];
        [btn setTitle:promotion.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:promotion.color] forState:UIControlStateNormal];
    }
}

- (void)iconButtonOnClick:(GPVerticalButton *)btn
{
    NSInteger index = [self.buttonsSuperview.subviews indexOfObject:btn];
    
    UINavigationController *navVc = [[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers firstObject];
    UIViewController *vc = nil;
    switch (index) {
        case 0:
        {
            // 美好小物
            vc = [[GPGoodLittleThingViewController alloc] init];
            break;
        }
        case 1:
        {
            vc = [[GPBrandViewController alloc] init];
            break;
        }
        case 2:
        {
            vc = [[GPSignViewController alloc] init];
            break;
        }
        case 3:
        {
            vc = [[GPDailyLuckyViewController alloc] init];
            break;
        }

        default:
            break;
    }
    [navVc pushViewController:vc animated:YES];

    
}

#pragma mark GPPageScrollViewDelegate
- (void)pageScrollView:(GPPageScrollView *)pageScrollView didClickImageAtIndex:(NSInteger)index
{
    GPBanner *banner = self.banners[index];
    UINavigationController *navVc = [[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers firstObject];
    
    if ([banner.type isEqualToString:@"collection"]) {
        NSString *firstPageURLString = [NSString stringWithFormat:@"http://api.liwushuo.com/v1/%@s/%@/posts?gender=1&generation=1&limit=20&offset=0", banner.type, banner.target_id];
        
        GPChannelViewController *channelVc = [[GPChannelViewController alloc] init];
        channelVc.firstPageURLString = firstPageURLString;
        channelVc.title = banner.target.title;
        channelVc.dataArrayName = @"posts";
        
        [navVc pushViewController:channelVc animated:YES];
    } else if ([banner.type isEqualToString:@"url"]){
        GPWebViewController *webVc= [[GPWebViewController alloc] init];
        webVc.webURLString = banner.target_url;
        webVc.title = banner.target.title;

        [navVc pushViewController:webVc animated:YES];
    }
    
}

#pragma mark 获取数据

- (void)getBannersData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel"] = @"iOS";
    [self.manager GET:@"http://api.liwushuo.com/v1/banners" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        self.banners = [GPBanner objectArrayWithKeyValuesArray:responseObject[@"data"][@"banners"]];
        TPCLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        TPCLog(@"%@", error);
    }];
}

- (void)getPromotionsData
{    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"gender"] = @"1";
    params[@"generation"] = @"1";
    [self.manager GET:@"http://api.liwushuo.com/v2/promotions" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        self.promotions = [GPPromotion objectArrayWithKeyValuesArray:responseObject[@"data"][@"promotions"]];
        TPCLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        TPCLog(@"%@", error);
    }];
}


- (void)dealloc
{
    [self.manager invalidateSessionCancelingTasks:YES];
}
@end
