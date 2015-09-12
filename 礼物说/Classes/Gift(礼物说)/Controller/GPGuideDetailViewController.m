//
//  TPCTacticDetailViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/15.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPGuideDetailViewController.h"
#import "GPDetailGiftController.h"
#import "GPGuideDetail.h"
#import "GPGuideBottomToolBar.h"
#import "GPGuideWebviewBottomToolBar.h"

@interface GPGuideDetailViewController() <UIWebViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) UIWebView *webView;

@property (weak, nonatomic) UIImageView *headerImageView;

@property (weak, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@property (strong, nonatomic) GPGuideDetail *guideDetail;

@property (weak, nonatomic) UIView *webViewMaskView;

@property (weak, nonatomic) GPGuideWebviewBottomToolBar *guideWebviewBottomToolBar;

@property (weak, nonatomic) GPGuideBottomToolBar *guideBottomToolBar;

@end

static const CGFloat GPGuideDetailHeaderH = 200;
static const CGFloat GPGuideDetailTitleBottomMargin = 15;
static const CGFloat GPGuideDetailTitleLeftMargin = 15;

#define GPGuideDetailTitleFont [UIFont systemFontOfSize:25.0]

@implementation GPGuideDetailViewController
#pragma mark 懒加载
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        _manager.session.configuration.timeoutIntervalForRequest = GPTimeoutIntervalForRequest;
    }
    
    return _manager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupHeaderImageView];
    
    [self setupWebview];
    
    [self setupTitleLabel];
    
    [self setupGuideBottomToolBar];
    
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)dealloc
{
    [self.manager invalidateSessionCancelingTasks:YES];
}
#pragma mark 初始化
- (void)setupNav
{
    self.view.backgroundColor = TPCBackgroundColor;
    self.title = @"攻略详情";
}

- (void)setupHeaderImageView
{
    // 先添加UIImageView
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, self.navigationController.navigationBar.gp_height + GPStatusBarH, TPCScreenW, GPGuideDetailHeaderH);
    [self.view addSubview:imageView];
    self.headerImageView = imageView;
    
    // 设置阴影
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    gradientLayer.opacity  = 0.6;
    gradientLayer.frame = self.headerImageView.bounds;
    [self.headerImageView.layer addSublayer:gradientLayer];
}

- (void)setupWebview
{
    // webView在imageView上面
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.scrollView.delegate = self;
    webView.backgroundColor = TPCBackgroundColor;
    webView.scrollView.backgroundColor = [UIColor clearColor];
    webView.backgroundColor = [UIColor clearColor];
    webView.frame = TPCScreenBounds;
    // 设置webView顶部偏移和底部偏移
    webView.scrollView.contentInset = UIEdgeInsetsMake(GPGuideDetailHeaderH + self.navigationController.navigationBar.gp_height + GPStatusBarH, 0, 0, 0);
    webView.scrollView.contentOffset = CGPointMake(0, -GPGuideDetailHeaderH - self.navigationController.navigationBar.gp_height - GPStatusBarH);
    [self.view addSubview:webView];
    self.webView = webView;
}

- (void)setupTitleLabel
{
    // 添加标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = GPGuideDetailTitleFont;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor whiteColor];
    [self.webView.scrollView addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)setupGuideBottomToolBar
{
    GPGuideBottomToolBar *guideBottomToolBar = [GPGuideBottomToolBar guideBottomToolBar];
    guideBottomToolBar.gp_width = TPCScreenW;
    guideBottomToolBar.gp_centerY = TPCScreenH - guideBottomToolBar.gp_height / 2.0;
    [self.view addSubview:guideBottomToolBar];
    self.guideBottomToolBar = guideBottomToolBar;
}

- (void)setupGuideWebviewBottomToolBar
{
    GPGuideWebviewBottomToolBar *guideWebviewBottomToolBar = [GPGuideWebviewBottomToolBar guideWebviewBottomToolBar];
    guideWebviewBottomToolBar.gp_width = self.webView.scrollView.contentSize.width;
    guideWebviewBottomToolBar.y = self.webView.scrollView.contentSize.height;
    [self.webView.scrollView addSubview:guideWebviewBottomToolBar];
    self.guideWebviewBottomToolBar = guideWebviewBottomToolBar;
    
    // 设置下边距
    UIEdgeInsets edgeInset = self.webView.scrollView.contentInset;
    edgeInset.bottom += guideWebviewBottomToolBar.gp_height;
    self.webView.scrollView.contentInset = edgeInset;
}

#pragma mark 加载数据

- (void)loadData
{
    NSString *guideDetailURLString = [NSString stringWithFormat:@"http://api.liwushuo.com/v1/posts/%ld", self.ID];

    [SVProgressHUD showWithStatus:@"正在加载图片详情"];
    [self.manager GET:guideDetailURLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        
        self.guideDetail = [GPGuideDetail objectWithKeyValues:responseObject[@"data"]];
        
        // 设置webView和imageView内容
        [self.webView loadHTMLString:self.guideDetail.content_html baseURL:nil];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.guideDetail.cover_image_url]];
        
        // 设置标题坐标
        [self adjustTitleLabelFrameWithText:self.guideDetail.title];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

// 调整标题坐标
- (void)adjustTitleLabelFrameWithText:(NSString *)text
{
    NSMutableDictionary *attributes = @{}.mutableCopy;
    attributes[NSFontAttributeName] = GPGuideDetailTitleFont;
    CGSize size = [text boundingRectWithSize:CGSizeMake(TPCScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    self.titleLabel.text = text;
    self.titleLabel.frame = CGRectMake(GPGuideDetailTitleLeftMargin, -(size.height + GPGuideDetailTitleBottomMargin), TPCScreenW - GPGuideDetailTitleBottomMargin, size.height);
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat upRate = 0.4;
    CGFloat downScale = 2.0;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (ABS(offsetY) < scrollView.contentInset.top) {
        // 往上挪，图片也往上挪
        self.headerImageView.transform = CGAffineTransformMakeTranslation(0, -(offsetY + scrollView.contentInset.top) * upRate);
    } else if (ABS(offsetY + scrollView.contentInset.top) < GPGuideDetailHeaderH / downScale) {
        // 往下挪小于图片高度的一半，图片进行放大
        CGFloat scale = -(offsetY + scrollView.contentInset.top) / GPGuideDetailHeaderH * downScale + 1;
        self.headerImageView.transform = CGAffineTransformMakeScale(scale, scale);
    } else {
        // 往下挪大于图片高度的一半，图片随scrollView一起向下挪
        self.headerImageView.transform = CGAffineTransformMakeTranslation(0, ABS(offsetY) - scrollView.contentInset.top - GPGuideDetailHeaderH / downScale);
        self.headerImageView.transform = CGAffineTransformScale(self.headerImageView.transform, downScale, downScale);
    }

    // 设置拉到底部时，toolBar的往下移
    if (ABS(scrollView.contentOffset.y) + TPCScreenH > scrollView.contentSize.height) {
        CGFloat scale = self.guideBottomToolBar.gp_height / self.guideWebviewBottomToolBar.gp_height;
        self.guideBottomToolBar.y = TPCScreenH - self.guideBottomToolBar.gp_height + (ABS(scrollView.contentOffset.y) + TPCScreenH - scrollView.contentSize.height) * scale;
    } else {
        // 滑动扫描并不会很准确，所以需要这一句确定底部toolBar的坐标
        self.guideBottomToolBar.y = TPCScreenH - self.guideBottomToolBar.gp_height;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!self.guideWebviewBottomToolBar) {
        // 使用webView加载完成后得到的contentSize不准确
        [self setupGuideWebviewBottomToolBar];
    }
    self.guideWebviewBottomToolBar.y = scrollView.contentSize.height;
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        // 点击内部详情链接，跳转到礼物详情界面
        NSArray *urlStrings = [request.URL.absoluteString componentsSeparatedByString:@"/"];
        GPDetailGiftController *GIftDetailVc = [[GPDetailGiftController alloc] init];
        GIftDetailVc.ID = [urlStrings lastObject];
        [self.navigationController pushViewController:GIftDetailVc animated:YES];
        
        return NO;
    } else {
        return YES;
    }
}
@end
