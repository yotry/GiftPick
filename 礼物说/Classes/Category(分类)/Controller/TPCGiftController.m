//
//  TPCGiftController.m
//  礼物说
//
//  Created by heew on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "TPCGiftController.h"
#import "GPCategoryCell.h"
#import "GPCategory.h"
#import "GPSubCategory.h"
#import "GPSubCategoryCell.h"
#import "GPSubCategoryReusableView.h"
#import "GPItemViewController.h"



@interface TPCGiftController () <UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate>
@property (nonatomic, weak) UITableView *categoryTablView; /**左侧分类 */
@property (nonatomic, weak) UICollectionView *giftCollectionView; /**右侧礼物详细 */
@property (nonatomic, strong) NSArray *categories; /**分类数组 */
@property (nonatomic, strong) AFHTTPSessionManager *manager; /**请求管理器 */
@property (assign, nonatomic) BOOL categoriesSelectedFlag;
@property (assign, nonatomic, getter=isDown) BOOL down; 
@end

@implementation TPCGiftController
- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        _manager.session.configuration.timeoutIntervalForRequest = 5;
    }
    return _manager;
}

- (NSArray *)categories {
    if (_categories == nil) {
        _categories = [NSArray array];
    }
    return _categories;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupTableView];
    
    [self setupCollectionView];
    
    [self sendHTTPRequest];
}

- (void)setupTableView {
    UITableView *categoryTablView = [[UITableView alloc] init];
    categoryTablView.dataSource = self;
    categoryTablView.delegate = self;
    categoryTablView.showsVerticalScrollIndicator = NO;
    categoryTablView.rowHeight = 40; /* bugfix：iphone5下高度不正确 tripleCC */
    [self.view addSubview:categoryTablView];
    categoryTablView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.categoryTablView = categoryTablView;
    [categoryTablView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.width.equalTo(70);
    }];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *giftCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:giftCollectionView];
    self.giftCollectionView = giftCollectionView;
    self.giftCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(sendHTTPRequest)];
    giftCollectionView.dataSource = self;
    giftCollectionView.delegate = self;
    giftCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    [giftCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.left.equalTo(self.categoryTablView.right);
    }];
    
    [self.giftCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GPSubCategoryCell class]) bundle:nil] forCellWithReuseIdentifier:subCategoryIdentifier];
    [self.giftCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GPSubCategoryReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
    self.giftCollectionView.backgroundColor = [UIColor whiteColor];
    CGFloat kItemMargin = 10.0;
    CGFloat kLineMargin = 10.0;
    CGFloat kLRsectionMargin = 5;
    
    flowLayout.minimumInteritemSpacing = kItemMargin;
    flowLayout.minimumLineSpacing = kLineMargin;
    flowLayout.sectionInset = UIEdgeInsetsMake(kLineMargin, kLRsectionMargin, 0, kLRsectionMargin);
    //每个cell的大小
    [self.giftCollectionView layoutIfNeeded];
    flowLayout.headerReferenceSize = CGSizeMake(self.giftCollectionView.bounds.size.width, 50);
    CGFloat itemW = (TPCScreenW - 5 * kItemMargin) * 0.25;
    CGFloat itemH = itemW * 1.5;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendHTTPRequest {
    
    NSString *descUrl = @"http://api.liwushuo.com/v2/item_categories/tree?";
    
    if (self.categories.count > 0) {
        [self.giftCollectionView.header endRefreshing];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在加载图片详情"];
    
    [self.manager GET:descUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        self.categories = [GPCategory objectArrayWithKeyValuesArray:responseObject[@"data"][@"categories"]];
        
        self.categoryTablView.header.hidden = YES;
        [self.categoryTablView reloadData];
        [self.giftCollectionView reloadData];
        
        // 默认设置为YES，以让默认选中第一行生效
        self.down = YES;
        // 加载完成，选中第一行
        [self.categoryTablView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.description];
        [self.giftCollectionView.header endRefreshing];
    }];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.categories.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    GPCategory *category = self.categories[section];
    return category.subcategories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GPCategory *category = self.categories[indexPath.section];
    GPSubCategory *subCategory = category.subcategories[indexPath.row];
    GPSubCategoryCell *cell = [GPSubCategoryCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.subCategory = subCategory;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    GPSubCategoryReusableView *reusableView = [GPSubCategoryReusableView reuseViewWithCollectionView:collectionView forIndexPath:indexPath];
    GPCategory *category = self.categories[indexPath.section];
    reusableView.catetory = category;
    
    return reusableView;
}

#pragma mark - UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GPCategory *category = self.categories[indexPath.section];
    GPSubCategory *subCategory = category.subcategories[indexPath.row];
    GPItemViewController *itemVc = [[GPItemViewController alloc] init];
    itemVc.firstPageURLString = [self subCategoryURLWithNumber:subCategory.ID];
    itemVc.title = subCategory.name;
    [self.navigationController pushViewController:itemVc animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    GPCategory *category = self.categories[indexPath.section];
    TPCLog(@"%zd---%zd",indexPath.row,category.subcategories.count);
    if (self.categoriesSelectedFlag == YES) return;
    
    
    // 最后一个item消失并且向下滚时，才更改tableView的选中cell
    if (indexPath.row == category.subcategories.count - 1 && self.isDown) {
        // 消失的是上一个section，所以加1
        NSInteger section = indexPath.section + 1;
        section = MIN(MAX(0, section), self.categories.count - 2);
        NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:section inSection:0];
        [self.categoryTablView selectRowAtIndexPath:categoryIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.categoriesSelectedFlag == YES) return;
    
    GPCategory *category = self.categories[indexPath.section];
    
    // 有一半展示出来，并且向上滚时才更改tableView的选中cell
    if (indexPath.row == category.subcategories.count / 2 && !self.isDown) {
        // 展示的是当前的section
        NSInteger section = indexPath.section;
        section = MIN(MAX(0, section), self.categories.count - 2);
        NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:section inSection:0];
        [self.categoryTablView selectRowAtIndexPath:categoryIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 手动滚动右边时，让collectionView决定tableVew的选中行
    self.categoriesSelectedFlag = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 一定要判断，难怪前面出了那么多bug，fuck！
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        static CGFloat previousOffsetY = 0;
        self.down = previousOffsetY <= scrollView.contentOffset.y;
        previousOffsetY = scrollView.contentOffset.y;
        
        // collectionView底部再下拉50，就选中tableView最后一个cell
        if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.gp_height + scrollView.contentInset.bottom + 40) {
            self.categoriesSelectedFlag = YES;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.categories.count - 1 inSection:0];
            [self.categoryTablView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

#pragma mark - TableViewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GPCategoryCell *cell = [GPCategoryCell cellWithTableView:tableView];
    GPCategory *category = self.categories[indexPath.row];
    cell.category = category;
    return cell;
}

#pragma mark - TableViewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *subCategoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
    [self.giftCollectionView selectItemAtIndexPath:subCategoryIndexPath animated:YES scrollPosition: UICollectionViewScrollPositionTop];
    
    // 点击tableView时，让collectionView不能影响tableView的选中行
    self.categoriesSelectedFlag = YES;
}

#pragma mark - 抽取出来,简化代码的方法
- (NSString *)subCategoryURLWithNumber:(NSInteger)number
{
    NSMutableString *channelURL = [NSMutableString stringWithString:@"http://api.liwushuo.com/v1/item_subcategories/"];
    [channelURL appendFormat:@"%ld", number];
    [channelURL appendString:@"/items?limit=20&offset=0"];
    
    return channelURL;
}
@end
