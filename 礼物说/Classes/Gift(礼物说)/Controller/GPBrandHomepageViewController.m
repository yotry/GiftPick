//
//  GPBrandHomepageViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPBrandHomepageViewController.h"
#import "GPDetailGiftController.h"
#import "GPBrandDetail.h"
#import "GPBrandDetailHeadImageView.h"
#import "GPBrandDetailSegment.h"
#import "GPSearchGiftCell.h"
#import "GPSearchGift.h"

@interface GPBrandHomepageViewController () <UIWebViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) AFHTTPSessionManager *manager;

@property (strong, nonatomic) GPBrandDetail *brandDetail;

@property (strong, nonatomic) NSMutableArray *gifts;

@property (strong, nonatomic) NSString *nextPageURLString;

@property (weak, nonatomic) UIView *headerView;

@property (weak, nonatomic) GPBrandDetailHeadImageView *brandDetailHeadImageView;

@property (weak, nonatomic) GPBrandDetailSegment *brandDetailSegment;

@property (weak, nonatomic) UIWebView *webView;

@property (weak, nonatomic) UICollectionView *collectionView;
@end

static const CGFloat GPBrandDetailHeadImageViewH = 150;

static const CGFloat GPBrandDetailSegmentH = 44;

#define  GPBrandDetailScrollViewContentInset UIEdgeInsetsMake(GPBrandDetailHeadImageViewH + GPBrandDetailSegmentH + GPStatusBarH + self.navigationController.navigationBar.gp_height, 0, 0, 0)

// 还原scrollView的偏移量
#define GPBrandMakeOffsetIdentify(view) \
{ \
    CGPoint offset = view.contentOffset; \
    offset.y = -(GPBrandDetailHeadImageViewH - GPBrandDetailSegmentH); \
    view.contentOffset = offset; \
}

@implementation GPBrandHomepageViewController
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
    
    [self setupWebview];
    
    [self setupCollectionView];
    
    [self setupHeaderView];
    
    [self loadBaseData];
    
    [self loadGiftsData];
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

- (void)setupWebview
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:TPCScreenBounds];
    webView.scrollView.delegate = self;
    webView.backgroundColor = TPCBackgroundColor;
    webView.scrollView.contentInset = GPBrandDetailScrollViewContentInset;
    [self.view addSubview:webView];
    self.webView = webView;
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (TPCScreenW - 3 * GPSearchGiftCellItemMarg) * 0.5;
    layout.itemSize = CGSizeMake(itemW, GPCollectionItemH);
    layout.minimumInteritemSpacing = GPSearchGiftCellItemMarg;
    layout.sectionInset = TPCTableViewCellUIEdgeInsets;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:TPCScreenBounds collectionViewLayout:layout];
    collectionView.contentInset = GPBrandDetailScrollViewContentInset;
    collectionView.backgroundColor = TPCBackgroundColor;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)setupHeaderView
{
    GPBrandDetailHeadImageView *brandDetailHeadImageView = [GPBrandDetailHeadImageView headImageView];
    brandDetailHeadImageView.frame = CGRectMake(0, 0, TPCScreenW, GPBrandDetailHeadImageViewH);
    self.brandDetailHeadImageView = brandDetailHeadImageView;
    
    GPBrandDetailSegment *brandDetailSegment = [GPBrandDetailSegment segment];
    brandDetailSegment.frame = CGRectMake(0, GPBrandDetailHeadImageViewH, TPCScreenW, GPBrandDetailSegmentH);
    [brandDetailSegment leftButtonAddTarget:self selector:@selector(allGiftButtonOnClick) forContrlEvents:UIControlEventTouchUpInside];
    [brandDetailSegment rightButtonAddTarget:self selector:@selector(brandDetailButtonOnClick) forContrlEvents:UIControlEventTouchUpInside];
    self.brandDetailSegment = brandDetailSegment;
    
    UIView *headerView = [[UIView alloc] init];
    CGFloat headerViewH = GPBrandDetailHeadImageViewH + GPBrandDetailSegmentH;
    headerView.frame = CGRectMake(0, -headerViewH, TPCScreenW, headerViewH);
    [headerView addSubview:brandDetailHeadImageView];
    [headerView addSubview:brandDetailSegment];
    [self.collectionView addSubview:headerView];
    self.headerView = headerView;
}

- (void)setupNav
{
    self.title = @"品牌主页";
    self.view.backgroundColor = TPCBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)loadBaseData
{
    NSString *homepageURL = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/brands/%ld", self.ID];
    [SVProgressHUD showWithStatus:@"正在加载图片详情"];
    [self.manager GET:homepageURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        
        self.brandDetail = [GPBrandDetail objectWithKeyValues:responseObject[@"data"]];
        
        self.brandDetailHeadImageView.brandDetail = self.brandDetail;
        [self.webView loadHTMLString:self.brandDetail.intro_html baseURL:nil];
        
        TPCLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

- (void)loadGiftsData
{
    NSString *firstURLString = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/brands/%ld/items?limit=20&offset=0", self.ID];
    [self.manager GET:firstURLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.nextPageURLString = responseObject[@"data"][@"paging"][@"next_url"];
        self.gifts = [GPSearchGift objectArrayWithKeyValuesArray:responseObject[@"data"][@"items"]];
        
        [self.collectionView reloadData];
        TPCLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
}

- (void)loadMoreData
{
    if (!self.nextPageURLString){
        [self checkFooterState];
        return;
    }
    
    [self.manager GET:self.nextPageURLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.gifts addObjectsFromArray:[GPSearchGift objectArrayWithKeyValuesArray:responseObject[@"data"][@"items"]]];
        
        [self.collectionView reloadData];
        
        NSString *nextURLString = responseObject[@"data"][@"paging"][@"next_url"];
        if ([nextURLString isKindOfClass:[NSNull class]] || [self.nextPageURLString isEqualToString:nextURLString]) {
            // 如果nextURLString是值为空的对象，就将self.nextPageURLString赋值为空对象
            // 注意nil和Null对象的区别，一个是空对象，一个是值为空的对象
            self.nextPageURLString = nil;
        } else {
            self.nextPageURLString = nextURLString;
        }
        [self checkFooterState];
        TPCLog(@"%@", self.nextPageURLString);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self checkFooterState];
        TPCLog(@"%@", error);
    }];
}

- (void)checkFooterState
{
    self.collectionView.footer.hidden = !self.gifts.count;
    if (self.nextPageURLString == nil) {
        self.collectionView.footer.hidden = YES;
    } else {
        [self.collectionView.footer endRefreshing];
    }
}

#pragma mark 切换界面
- (void)allGiftButtonOnClick
{
    self.webView.hidden = YES;
    self.collectionView.hidden = NO;
    [self.collectionView addSubview:self.headerView];
    
    // 只有当segment悬停时才执行
    if (self.brandDetailSegment.superview != self.headerView) {
        GPBrandMakeOffsetIdentify(self.collectionView);
    } else {
        self.collectionView.contentOffset = self.webView.scrollView.contentOffset;
    }
}

- (void)brandDetailButtonOnClick
{
    self.webView.hidden = NO;
    self.collectionView.hidden = YES;
    [self.webView.scrollView addSubview:self.headerView];

    // 只有当segment悬停时才执行
    if (self.brandDetailSegment.superview != self.headerView) {
        GPBrandMakeOffsetIdentify(self.webView.scrollView);
    } else {
        self.webView.scrollView.contentOffset = self.collectionView.contentOffset;
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > -GPBrandDetailScrollViewContentInset.top + GPBrandDetailHeadImageViewH) {
        [self.view addSubview:self.brandDetailSegment];
        self.brandDetailSegment.frame = CGRectMake(0, self.navigationController.navigationBar.gp_height + GPStatusBarH, TPCScreenW, self.navigationController.navigationBar.gp_height);
    }else {
        [self.headerView addSubview:self.brandDetailSegment];
        self.brandDetailSegment.frame = CGRectMake(0, GPBrandDetailHeadImageViewH, TPCScreenW, self.navigationController.navigationBar.gp_height);
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [self checkFooterState];
    return self.brandDetail.image_urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GPSearchGiftCell *cell = [GPSearchGiftCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.gift = self.gifts[indexPath.row];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GPSearchGift *gift = self.gifts[indexPath.row];
    GPDetailGiftController *giftDetailController = [[GPDetailGiftController alloc] init];
    giftDetailController.ID = gift.ID;
    [self.navigationController pushViewController:giftDetailController animated:YES];
}
@end

