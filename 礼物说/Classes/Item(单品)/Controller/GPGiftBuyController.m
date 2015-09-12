//
//  GPGiftBuyController.m
//  礼物说
//
//  Created by heew on 15/1/19.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPGiftBuyController.h"

@interface GPGiftBuyController () <UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView; /**webview */
@property (nonatomic, strong) NJKWebViewProgress *progress; /**进度值 */
@end

@implementation GPGiftBuyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWebView];
 
    [self setupWebprogressView];
}

- (void)setupWebView {
    UIWebView *webView = [[UIWebView alloc] init];
    [self.view addSubview:webView];
    webView.delegate = self;
    [webView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.webView = webView;
    NSURL *URL = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:request];
}

- (void)setupWebprogressView {
    NJKWebViewProgressView *webProgressView = [[NJKWebViewProgressView alloc] init];
    [self.view addSubview:webProgressView];
    [webProgressView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.equalTo(self.view);
        make.height.equalTo(5);
    }];
    
    self.progress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progress;
    __weak typeof(webProgressView) weakwebProgressView = webProgressView;
    self.progress.progressBlock = ^(float progress) {
        weakwebProgressView.progress = progress;
    };
    self.progress.webViewProxyDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webProgresView代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"加载完了");
}

@end
