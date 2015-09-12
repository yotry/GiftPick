//
//  TPCGiftBaceViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/9.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPChannelViewController.h"
#import "GPGuideDetailViewController.h"
#import "GPFeedPostCell.h"
#import "GPItem.h"

@interface GPChannelViewController ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

/** 下一页url */
@property (strong, nonatomic) NSString *nextPageURLString;

/** 商品条目 */
@property (strong, nonatomic) NSMutableArray *items;
@end

static NSString *const reuseIdentifier = @"items";

@implementation GPChannelViewController

#pragma mark 懒加载
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
}

#pragma mark 初始化
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    GPChannelViewController *vc = [super initWithStyle:UITableViewStylePlain];
    vc.cellBackgroundColor = [UIColor clearColor];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupRefresh];
}

- (void)dealloc
{
    [self.manager invalidateSessionCancelingTasks:YES];
}

- (void)setupTableView
{
    self.tableView.rowHeight = 150.0;
    self.tableView.contentInset = UIEdgeInsetsMake(TPCTableViewCellUIEdgeInsets.top, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TPCBackgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GPFeedPostCell class]) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
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
    if (self.firstPageURLString == nil){
        [self.tableView.header endRefreshing];
        return;
    }
    TPCLog(@"%@", self.firstPageURLString);
    [self.manager GET:self.firstPageURLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.items = [GPItem objectArrayWithKeyValuesArray:responseObject[@"data"][self.dataArrayName]];
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
    if (!self.nextPageURLString){
        [self checkFooterState];
        return;
    }
    [self.manager GET:self.nextPageURLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.items addObjectsFromArray:[GPItem objectArrayWithKeyValuesArray:responseObject[@"data"][self.dataArrayName]]];
        
        [self.tableView.header endRefreshing];

        [self.tableView reloadData];
        
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
    TPCLog(@"%ld", self.items.count);
    [self checkFooterState];
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GPFeedPostCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.item = self.items[indexPath.row];
    cell.backgroundColor = self.cellBackgroundColor;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GPItem *item = self.items[indexPath.row];

    GPGuideDetailViewController *guideDetailVc = [[GPGuideDetailViewController alloc] init];
    guideDetailVc.ID = item.ID;
    [self.navigationController pushViewController:guideDetailVc animated:YES];
}

@end
