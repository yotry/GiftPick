//
//  GPBrandViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/16.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPBrandViewController.h"
#import "GPBrandCell.h"
#import "GPBrand.h"
#import "GPBrandHomepageViewController.h"

@interface GPBrandViewController ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;

/** 下一页url */
@property (strong, nonatomic) NSString *nextPageURLString;

/** 商店 */
@property (strong, nonatomic) NSMutableArray *brands;
@end

static NSString *const reuseIdentifier = @"brands";

@implementation GPBrandViewController
#pragma mark 懒加载
- (NSMutableArray *)brands
{
    if (_brands == nil) {
        _brands = @[].mutableCopy;
    }
    
    return _brands;
}
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
    
    [self setupTableView];
    
    [self setupRefresh];
}

- (void)dealloc
{
    [self.manager invalidateSessionCancelingTasks:YES];
}

- (void)setupNav
{
    self.title = @"品牌专区";
}

- (void)setupTableView
{
    self.tableView.rowHeight = 200.0;
    self.tableView.contentInset = UIEdgeInsetsMake(TPCTableViewCellUIEdgeInsets.top, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TPCBackgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GPBrandCell class]) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.tableView.header beginRefreshing];
    self.tableView.footer.hidden = YES;
}

#pragma mark 加载数据
- (void)loadNewData
{
    NSString *firstPageURLString = @"http://api.liwushuo.com/v2/brands/editor?limit=20&offset=0";
    [self.manager GET:firstPageURLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.brands = [GPBrand objectArrayWithKeyValuesArray:responseObject[@"data"][@"brands"]];
        self.nextPageURLString = responseObject[@"data"][@"paging"][@"next_url"];
        TPCLog(@"%@", responseObject);
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.header endRefreshing];
        TPCLog(@"%@", error);
    }];
}

- (void)loadMoreData
{
    NSLog(@"%@", self.nextPageURLString);
    if (!self.nextPageURLString){
        [self checkFooterState];
        return;
    }
    [self.manager GET:self.nextPageURLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.brands addObjectsFromArray:[GPBrand objectArrayWithKeyValuesArray:responseObject[@"data"][@"brands"]]];
        
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
        
        NSString *nextURLString = responseObject[@"data"][@"paging"][@"next_url"];
        if ([nextURLString isKindOfClass:[NSNull class]] || [self.nextPageURLString isEqualToString:nextURLString]) {
            // 如果nextURLString是值为空的对象，就将self.nextPageURLString赋值为空对象
            // 注意nil和Null对象的区别，一个是空对象，一个是值为空的对象
            self.nextPageURLString = nil;
            return;
        } else {
            self.nextPageURLString = nextURLString;
        }
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self checkFooterState];
        TPCLog(@"%@", error);
    }];
}

- (void)checkFooterState
{
    if (self.nextPageURLString == nil) {
//        [self.tableView.footer noticeNoMoreData];
                self.tableView.footer.hidden = YES;
    } else {
        [self.tableView.footer endRefreshing];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self checkFooterState];
    return self.brands.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GPBrandCell *brandCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    brandCell.brand = self.brands[indexPath.row];
    brandCell.bigImageViewLeft = indexPath.row % 2;

    return brandCell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GPBrandHomepageViewController *brandHomepageViewController = [[GPBrandHomepageViewController alloc] init];
    brandHomepageViewController.ID = [self.brands[indexPath.row] ID];
    [self.navigationController pushViewController:brandHomepageViewController animated:YES];
}
@end
