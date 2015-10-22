//
//  TPCCategoryViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/8.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "TPCRaidersController.h"
#import "GPRaidersCell.h"
#import "GPRaidersReuseView.h"
#import "GPChannelGroup.h"
#import "GPChannel.h"
#import "GPRaiderHeaderView.h"
#import "GPRaiderCollection.h"
#import "GPChannelViewController.h"



@interface TPCRaidersController () <RaiderHeaderViewDelegate>
@property (nonatomic, strong) AFHTTPSessionManager *manager; /**请求管理器 */
@property (weak, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *channelGroups; /**分类攻略模型数组 */
@property (nonatomic, weak) GPRaiderHeaderView *headerView; /**攻略顶部滚动控件 */
@property (nonatomic, strong) NSArray *collections; /**顶部控件模型数组 */
@end

@implementation TPCRaidersController

- (instancetype)init {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout = flowLayout;
    return [super initWithCollectionViewLayout:flowLayout];
}

- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        _manager.session.configuration.timeoutIntervalForRequest = 5;
    }
    return _manager;
}

- (NSMutableArray *)channelGroups {
    if (_channelGroups == nil) {
        _channelGroups = [NSMutableArray array];
    }
    return _channelGroups;
}

- (NSArray *)collections {
    if (_collections == nil) {
        _collections = [NSArray array];
    }
    return _collections;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);//
    

    [self setupCollectionView];
    
    [self setupFLowLayout];
    
    [self setupRaiderHeaderView];
    
    [self loadHeaderData];
}

- (void)loadHeaderData {
    NSString *descUrl = @"http://api.liwushuo.com/v1/collections?limit=6&offset=0";
    if (self.headerView.collections.count > 0) return;
    [self.manager GET:descUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.headerView.collections = [GPRaiderCollection objectArrayWithKeyValuesArray:responseObject[@"data"][@"collections"]];
//        NSLog(@"%zd",self.headerView.collections.count);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络各种卡"];
    }];
}

- (void)setupRaiderHeaderView {
    GPRaiderHeaderView *headerView = [GPRaiderHeaderView raiderHeaderView];
    headerView.delegate = self;
    [self.collectionView addSubview:headerView];
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.collectionView.top);
        make.left.right.equalTo(self.view);
        make.height.equalTo(150);
    }];
    [headerView layoutIfNeeded];
    self.collectionView.contentInset = UIEdgeInsetsMake(headerView.gp_height, 0, 0, 0);
    self.collectionView.header.ignoredScrollViewContentInsetTop = headerView.gp_height;
    self.headerView = headerView;
}

- (void)setupCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GPRaidersCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GPRaidersReuseView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadItemsData)];
    [self.collectionView.header beginRefreshing];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)setupFLowLayout {
    
    CGFloat kItemMargin = 10.0;
    CGFloat kLineMargin = 10.0;
    CGFloat kLRsectionMargin = 5;
    
    self.flowLayout.minimumInteritemSpacing = kItemMargin;
    self.flowLayout.minimumLineSpacing = kLineMargin;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(kLineMargin, kLRsectionMargin, 0, kLRsectionMargin);
    //每个cell的大小
    self.flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 50);
    CGFloat itemW = (TPCScreenW - 5 * kItemMargin) * 0.25;
    CGFloat itemH = itemW * 1.5;
    self.flowLayout.itemSize = CGSizeMake(itemW, itemH);
}

- (void)loadItemsData {
    
    [self loadHeaderData];
    
    NSString *descUrl = @"http://api.liwushuo.com/v1/channel_groups/all?";
    
    if (self.channelGroups.count > 0) {
        [self.collectionView.header endRefreshing];
        return;
    }
    
    
    [self.manager GET:descUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.channelGroups = [GPChannelGroup objectArrayWithKeyValuesArray:responseObject[@"data"][@"channel_groups"]];
        
        [self.collectionView reloadData];
        
        [self.collectionView.header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网速卡成狗"];
        [self.collectionView.header endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.channelGroups.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    GPChannelGroup *group = self.channelGroups[section];
    return group.channels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GPRaidersCell *cell = [GPRaidersCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    
    GPChannelGroup *group = self.channelGroups[indexPath.section];
    GPChannel *channel = group.channels[indexPath.item];
    
    cell.channel = channel;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    GPRaidersReuseView *reuseView = [GPRaidersReuseView reuseViewWithCollectionView:collectionView forIndexPath:indexPath];
    GPChannelGroup *channelGroup = self.channelGroups[indexPath.section];
    reuseView.channelGroup = channelGroup;
    return reuseView;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GPChannelGroup *group = self.channelGroups[indexPath.section];
    GPChannel *channel = group.channels[indexPath.item];
    GPChannelViewController *channelVc = [[GPChannelViewController alloc] init];
    
    channelVc.title = channel.name;
    channelVc.dataArrayName = @"items";
    channelVc.firstPageURLString = [self channelURLWithNumber:channel.ID];
    
    [self.navigationController pushViewController:channelVc animated:YES];
}

#pragma mark - RaiderHeaderViewDelegate
- (void)raiderHeaderViewDidClickCheckAllButton:(GPRaiderHeaderView *)headerView {
    NSLog(@"---");
}

- (void)raiderHeaderViewDidClickWithCollection:(GPRaiderCollection *)collection {
    GPChannelViewController *channelVc = [[GPChannelViewController alloc] init];
    
    channelVc.title = collection.title;
    channelVc.dataArrayName = @"items";
    channelVc.firstPageURLString = [self channelURLWithNumber:collection.ID];
    
    [self.navigationController pushViewController:channelVc animated:YES];
}

- (NSString *)channelURLWithNumber:(NSInteger)number
{
    NSMutableString *channelURL = [NSMutableString stringWithString:@"http://api.liwushuo.com/v1/channels/"];
    [channelURL appendFormat:@"%ld", number];
    [channelURL appendString:@"/items?limit=20&offset=0"];
    
    return channelURL;
}
@end
