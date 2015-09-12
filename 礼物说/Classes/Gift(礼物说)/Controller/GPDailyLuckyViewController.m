//
//  GPDailyLuckyViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/17.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPDailyLuckyViewController.h"

@interface GPDailyLuckyViewController ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (weak, nonatomic) UIWebView *webView;
@end

@implementation GPDailyLuckyViewController

- (void)loadView
{
    self.view = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.webView = (UIWebView *)self.view;
}
#pragma mark 懒加载
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
}

#pragma mark 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self getHTMLData];
    [self getUserSignData];
}

- (void)setupNav
{
    self.title = @"天天刮奖";
    self.view.backgroundColor = TPCBackgroundColor;
}

#pragma mark 加载数据
- (void)getHTMLData
{
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:@"http://event.liwushuo.com/topics/daily-lucky" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [self.webView loadHTMLString:htmlString baseURL:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        TPCLog(@"%@", error);
    }];
}

- (void)getUserSignData
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"_"] = @(1439788878212);
    
    [self.manager GET:@"http://event.liwushuo.com/event-api/me" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        TPCLog(@"%@", error);
    }];
}
@end
