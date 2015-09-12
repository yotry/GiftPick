//
//  TPCItemViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/8.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPItemViewController.h"
#import "GPSearchGiftCell.h"
#import "GPSearchGift.h"
#import "GPSearchGiftHeader.h"
#import "GPDetailGiftController.h"


@interface GPItemViewController ()
@property (nonatomic, strong) AFHTTPSessionManager *manager; /**请求管理器 */
@property (nonatomic, strong) NSString *nextPageUrl; /**下一页数据 */
@property (nonatomic, strong) NSMutableArray *searchGifts; /**礼物数组 */
@end

@implementation GPItemViewController
- (NSString *)firstPageURLString {
    if (_firstPageURLString== nil) {
        _firstPageURLString = @"http://api.liwushuo.com/v2/items?gender=1&generation=1&limit=20&offset=0";
    }
    return _firstPageURLString;
}
- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        _manager.session.configuration.timeoutIntervalForRequest = 5;
    }
    return _manager;
}

- (NSMutableArray *)searchGifts {
    if (_searchGifts == nil) {
        _searchGifts = [NSMutableArray array];;
    }
    return _searchGifts;
}

- (instancetype)init {
    CGFloat w = (TPCScreenW - 3 * GPSearchGiftCellItemMarg) * 0.5;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(w, GPCollectionItemH);
    flowLayout.minimumInteritemSpacing = GPSearchGiftCellItemMarg;
    flowLayout.sectionInset = TPCTableViewCellUIEdgeInsets;
    return [super initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"单品";
    
    self.collectionView.header = [GPSearchGiftHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.collectionView.header beginRefreshing];
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.collectionView.backgroundColor = TPCBackgroundColor;
}

- (void)loadNewData {
    [self.manager GET:self.firstPageURLString parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        [self.searchGifts removeAllObjects];
        self.nextPageUrl = responseObject[@"data"][@"paging"][@"next_url"];
        
        NSArray *array = responseObject[@"data"][@"items"];
        if ([[array firstObject][@"type"] isEqualToString:@"item"]) {
            for (NSDictionary *dict in array) {
                GPSearchGift *gift = [GPSearchGift objectWithKeyValues:dict[@"data"]];
                [self.searchGifts addObject:gift];
            }
        }else {
            [self.searchGifts addObjectsFromArray:[GPSearchGift objectArrayWithKeyValuesArray:array]];
        }

        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionView.header endRefreshing];
    }]; 
}

- (void)loadMoreData {
    [self.manager GET:self.nextPageUrl parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        self.nextPageUrl = responseObject[@"data"][@"paging"][@"next_url"];
//        TPCLog(@"%@",nextPageUrl);
        
        NSArray *array = responseObject[@"data"][@"items"];
        if ([[array firstObject][@"type"] isEqualToString:@"item"]) {
            for (NSDictionary *dict in array) {
                GPSearchGift *gift = [GPSearchGift objectWithKeyValues:dict[@"data"]];
                [self.searchGifts addObject:gift];
            }
        }else {
            [self.searchGifts addObjectsFromArray:[GPSearchGift objectArrayWithKeyValuesArray:array]];
        }
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.collectionView.footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchGifts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GPSearchGiftCell *cell = [GPSearchGiftCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    GPSearchGift *gift = self.searchGifts[indexPath.item];
    cell.gift = gift;
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GPDetailGiftController *giftDetailVc = [[GPDetailGiftController alloc] init];
    GPSearchGift *gift = self.searchGifts[indexPath.item];
    giftDetailVc.ID = gift.ID;
    [self.navigationController pushViewController:giftDetailVc animated:YES];
}

#pragma mark - 导航控制器push

@end
