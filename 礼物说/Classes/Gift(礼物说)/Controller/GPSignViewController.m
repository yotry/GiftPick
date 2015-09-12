//
//  GPSignViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/17.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPSignViewController.h"

@interface GPSignViewController ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (weak, nonatomic) UIWebView *webView;
@end

@implementation GPSignViewController
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

- (void)dealloc
{
    [self.manager invalidateSessionCancelingTasks:YES];
}

- (void)setupNav
{
    self.title = @"每日签到";
    self.view.backgroundColor = TPCBackgroundColor;
}

#pragma mark 加载数据
- (void)getHTMLData
{
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager GET:@"http://www.liwushuo.com/credit/sign" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", htmlString);
        [self.webView loadHTMLString:htmlString baseURL:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        TPCLog(@"%@", error);
    }];
}

- (void)getUserSignData
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"_"] = @(1439788878212);
    
    [self.manager GET:@"http://www.liwushuo.com/api/credit/me" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        TPCLog(@"%@", error);
    }];
}

@end
