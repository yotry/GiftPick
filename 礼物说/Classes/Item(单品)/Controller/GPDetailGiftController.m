//
//  GPGIftDetailController.m
//  礼物说
//
//  Created by heew on 15/1/16.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPDetailGiftController.h"
#import "GPPageScrollView.h"
#import "GPSegment.h"
#import "GPSearchGift.h"
#import "GPDetailHeader.h"
#import "GPGiftComment.h"
#import "GPDetailGiftCell.h"
#import "GPGiftComment.h"
#import "GPGiftBuyController.h"
#import "UMSocial.h"
#import "UMSocialConfig.h"


@interface GPDetailGiftController () <UIScrollViewDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
@property (nonatomic, strong) GPSearchGift *gift; /**单品模型 */
@property (nonatomic, weak) UIView *containerView; /**滚动视图 */
@property (nonatomic, weak) GPDetailHeader *detailHeader; /**顶部控件 */
@property (nonatomic, weak) GPSegment *segment; /**选择标签 */
@property (nonatomic, weak) UIWebView *webView; /**详情页面 */
@property (nonatomic, weak) UITableView *tableView; /**评论页面 */
@property (nonatomic, strong) AFHTTPSessionManager *manager; /**请求管理器 */
@property (nonatomic, assign) CGFloat containerHeight; /**顶部容器高度 */
@property (nonatomic, strong) NSMutableArray *comments; /**评论模型数组 */
@property (nonatomic, strong) NSString *nextPage; /**记录下一次请求地址 */
@property (nonatomic, strong) UIImage *shareImage; /**分享图片 */

@end

@implementation GPDetailGiftController

- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        _manager.session.configuration.timeoutIntervalForRequest = 5;
    }
    return _manager;
}

- (NSMutableArray *)comments {
    if (_comments == nil) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"商品详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self sendHTTPRequest];

    [self setupRightNavigationItem];
}

- (void)setupRightNavigationItem {
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithbg:@"share" bgHighlighted:nil target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)share {
    NSString *appKey = @"55d525fd67e58e7ffb0060ec";
    NSString *shareText = [NSString stringWithFormat:@"%@,%@",self.gift.giftDescription,self.gift.url];
    UIImage *image = self.shareImage;
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
//    [UMSocialSnsService presentSnsController:self appKey:appKey shareText:shareText shareImage:image shareToSnsNames:snsNames delegate:nil];
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:appKey
                                      shareText:shareText
                                     shareImage:image
                                shareToSnsNames:snsNames
                                       delegate:self];
    
//    NSDictionary *dict = [UMSocialSnsPlatformManager sharedInstance].allSnsPlatformDictionary;
//    
//    UMSocialSnsPlatform *douban = dict[@"douban"];
////    douban.bigImageName = @"sns_icon_5";
//    douban.smallImageName =  @"sns_icon_5";
//    
//    UMSocialSnsPlatform *renren = dict[@"renren"];
//    renren.bigImageName = @"sns_icon_7";


}



#pragma mark - 设置UI界面
- (void)sendHTTPRequest {
    
    NSString *descUrl = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/items/%@?",self.ID];
//    NSLog(@"%@",descUrl);
    [SVProgressHUD showWithStatus:@"正在加载图片详情"];
    
    [self.manager GET:descUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        self.gift = [GPSearchGift objectWithKeyValues:responseObject[@"data"]];
        
        [self setupWebView];
        
        [self setupContainerView];
        
        [self setupDeailHeader];
        
        [self setupSegment];
        
        [self setupTableView];
        
        [self setupsegmentClick];
        
        [self setupBottomBar];
        
        [self setupSharImage];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.description];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setupWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:TPCScreenBounds];
    webView.gp_height = TPCScreenH - 44;
    [self.view addSubview:webView];
    webView.scrollView.delegate = self;
    [webView loadHTMLString:self.gift.detail_html baseURL:nil];
    webView.backgroundColor = TPCBackgroundColor;
    self.webView = webView;
}

- (void)setupContainerView {
    UIView *containerView = [[UIView alloc] init];
    [self.webView.scrollView addSubview:containerView];
    self.containerView = containerView;
}

- (void)setupDeailHeader {
    GPDetailHeader *detailHeader = [GPDetailHeader detailHeader];
    self.detailHeader = detailHeader;
    detailHeader.gift = self.gift;
    [self.containerView addSubview:detailHeader];
    detailHeader.frame = CGRectMake(0, 0, TPCScreenW, self.gift.detailHeaderHeight);
}

- (void)setupSegment {
    GPSegment *segment = [GPSegment segment];
    [self.containerView addSubview:segment];
    segment.frame = CGRectMake(0, self.gift.detailHeaderHeight , TPCScreenW, 44);
    segment.gift = self.gift;
    self.segment = segment;
    CGFloat containerH = CGRectGetMaxY(self.segment.frame);
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(containerH + 64, 0, 0, 0);
    self.containerView.frame = CGRectMake(0, -containerH, TPCScreenW, containerH);
    self.containerHeight = containerH;
}

- (void)setupsegmentClick {
    [self.segment descButtonAddTarget:self selector:@selector(descClick) forContrlEvents:UIControlEventTouchUpInside];
    [self descClick];
    [self.segment commentButtonAddTarget:self selector:@selector(commentClick) forContrlEvents:UIControlEventTouchUpInside];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:TPCScreenBounds];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = TPCBackgroundColor;
    tableView.contentInset = UIEdgeInsetsMake(self.containerHeight + 64, 0, 0, 0);
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 80;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [tableView.footer beginRefreshing];
    self.tableView = tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupBottomBar {
    UIView *bottomBar = [[UIView alloc] init];
    [self.view addSubview:bottomBar];
    bottomBar.backgroundColor = [UIColor whiteColor];
    [bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(44);
    }];
    bottomBar.layer.borderWidth = 1;
    bottomBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    NSInteger kVerticalMargin = 6;
    NSInteger kHorizontalMargin = 20;
    
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton setTitle:@"喜欢" forState:UIControlStateNormal];
    likeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [likeButton setTitleColor:TPCThemeColor forState:UIControlStateNormal];
    [bottomBar addSubview:likeButton];
    [likeButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBar.left).offset(kHorizontalMargin);
        make.top.equalTo(bottomBar).offset(kVerticalMargin);
        make.bottom.equalTo(bottomBar.bottom).offset(-kVerticalMargin);
        make.width.equalTo(self.view).dividedBy(3.4);
    }];
    [likeButton layoutIfNeeded];
    likeButton.layer.cornerRadius = likeButton.gp_height * 0.5;
    likeButton.layer.borderColor = TPCThemeColor.CGColor;
    likeButton.layer.borderWidth = 1;
    likeButton.clipsToBounds = YES;
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBar addSubview:buyButton];
    [buyButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomBar.top).offset(kVerticalMargin);
        make.bottom.equalTo(bottomBar.bottom).offset(-kVerticalMargin);
        make.right.equalTo(bottomBar.right).offset(-kHorizontalMargin);
        make.width.equalTo(self.view).dividedBy(2);
    }];
    [buyButton setTitle:@"去天猫购买" forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton setBackgroundColor:TPCThemeColor];
    [buyButton layoutIfNeeded];
    buyButton.layer.cornerRadius = buyButton.gp_height * 0.5;
    buyButton.clipsToBounds = YES;
    [buyButton addTarget:self action:@selector(buyGift) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSharImage {
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.gift.cover_image_url] options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        self.shareImage = image;
    }];
}

- (void)buyGift {
    NSString *taobaoUrl = [self.gift.purchase_url stringByReplacingOccurrencesOfString:@"http://" withString:@"taobao://"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:taobaoUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:taobaoUrl]];
    } else {
        GPGiftBuyController *buyVc = [[GPGiftBuyController alloc] init];
        buyVc.url = self.gift.purchase_url;
        [self.navigationController pushViewController:buyVc animated:YES];
    }
}
#pragma mark - scrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > -108) {
        [self.view addSubview:self.segment];
        self.segment.frame = CGRectMake(0, 64, TPCScreenW, 44);
    }else {
        [self.containerView addSubview:self.segment];
        self.segment.frame = CGRectMake(0, self.gift.detailHeaderHeight , TPCScreenW, 44);
    }
    
    if (offsetY < -self.containerHeight-64) {
        CGFloat scale = offsetY / (-self.containerHeight-64);
        self.detailHeader.pageView.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

#pragma mark - segment按钮点击
- (void)descClick {
    self.webView.hidden = NO;
    self.tableView.hidden = YES;
    [self.webView.scrollView addSubview:self.containerView];
    self.webView.scrollView.contentOffset = self.tableView.contentOffset;
}

- (void)commentClick {
    self.webView.hidden = YES;
    self.tableView.hidden = NO;
    [self.tableView addSubview:self.containerView];
    self.tableView.contentOffset = self.webView.scrollView.contentOffset;
}

#pragma mark - loadMoreData加载评论数据
- (void)loadMoreData {
    self.nextPage = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/items/%@/comments?limit=20&offset=0",self.ID];
    [self.manager GET:self.nextPage parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.comments addObjectsFromArray:[GPGiftComment objectArrayWithKeyValuesArray:responseObject[@"data"][@"comments"]]];
        self.nextPage = responseObject[@"data"][@"paging"][@"next_url"];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        if (self.comments.count >= self.gift.comments_count) {
            [self.tableView.footer noticeNoMoreData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GPDetailGiftCell *cell = [GPDetailGiftCell cellWithTableView:tableView];
    GPGiftComment *comment = self.comments[indexPath.row];
    cell.comment = comment;
    return cell;
}


@end
