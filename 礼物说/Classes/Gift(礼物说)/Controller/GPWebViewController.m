//
//  GPWebViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/24.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPWebViewController.h"
#import "UMSocial.h"

@interface GPWebViewController () <UIWebViewDelegate>

@end

@implementation GPWebViewController
#pragma mark 初始化
- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    self.view = webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNav];
    
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)setupNav
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
}

- (void)loadData
{
    UIWebView *webView = (UIWebView *)self.view;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webURLString]];
    [SVProgressHUD showWithStatus:@"正在加载"];
    [webView loadRequest:request];
}

- (void)share
{
    NSString *appKey = @"55d525fd67e58e7ffb0060ec";
    NSString *shareText = [NSString stringWithFormat:@"%@,%@", self.title, self.webURLString];
    NSArray *snsNames = @[UMShareToDouban, UMShareToEmail, UMShareToRenren, UMShareToSina, UMShareToWechatSession, UMShareToWechatTimeline];
    
    [UMSocialConfig setTheme:UMSocialThemeBlack];
    
    [UMSocialConfig setShareGridViewTheme:^(CGContextRef ref, UIImageView *backgroundView,UILabel *label){
        //改变线颜色和线宽
        CGContextSetRGBStrokeColor(ref, 0, 0, 0, 1.0);
        CGContextSetLineWidth(ref, 1.0);
        //改变背景颜色
        backgroundView.backgroundColor = [UIColor blackColor];
        
        //添加背景图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:backgroundView.frame];
        imageView.image = [UIImage imageNamed:@"Me_ProfileBackground"];
        [backgroundView addSubview:imageView];
        backgroundView.backgroundColor = [UIColor clearColor];
        
        //改变文字标题的文字颜色
        label.textColor = [UIColor blueColor];
        //隐藏文字
        label.hidden = YES;
    }];

    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:appKey
                                      shareText:shareText
                                     shareImage:nil
                                shareToSnsNames:snsNames
                                       delegate:nil];
}

#pragma mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 设置控制器标题
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
    
    [SVProgressHUD dismiss];
}
@end
