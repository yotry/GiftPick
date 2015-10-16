//
//  GBSearchViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/24.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPSearchViewController.h"
#import "GPBrandDetailSegment.h"
#import "GPHotWordsCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "GPChannelViewController.h"
#import "GPItemViewController.h"
#import "GPSaveTool.h"
#import "GPHotWordsCollectionViewFooter.h"
#import "GPHotWordsCollectionViewHeader.h"


@interface GPSearchViewController () <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *hotWordsCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotWordsCollectionToViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *resultContainerView;
@property (weak, nonatomic) GPBrandDetailSegment *resultSegement;
@property (weak, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) AFHTTPSessionManager *manager;

@property (weak, nonatomic) UIView *giftResultView;
@property (weak, nonatomic) UIView *guideResultView;

@property (strong, nonatomic) NSArray *hotWords;
@property (strong, nonatomic) NSMutableArray *searchHistory;
@property (strong, nonatomic) NSMutableArray *collectionDataArray;
@end

static NSString *const reuseItemIdentifier = @"hotWordItem";
static NSString *const reuseHeaderIdentifier = @"hotWordHeader";
static NSString *const reuseFooterIdentifier = @"hotWordFooter";
static const CGFloat GPHotWordsCellHorizontalMargin = 15;
static const CGFloat GPHotWordsCellVerticalMargin = 7;
static const CGFloat GPHotWordReuseHeaderH = 35;
static const CGFloat GPResultSegementH = 44;
static const CGFloat GPHotWordsCollectionFootertH = 40;
static const CGFloat GPHotWordsCollectionMargin = 10;

@implementation GPSearchViewController
#pragma mark 懒加载

- (NSMutableArray *)searchHistory
{
    if (_searchHistory == nil) {
        _searchHistory = @[].mutableCopy;
    }
    
    return _searchHistory;
}

- (NSMutableArray *)collectionDataArray
{
    if (_collectionDataArray == nil) {
        _collectionDataArray = @[].mutableCopy;
        if (self.searchHistory.count) {
            [_collectionDataArray addObject:self.searchHistory];
        }
    }
    
    return _collectionDataArray;
}

- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
}

- (GPBrandDetailSegment *)resultSegement
{
    if (_resultSegement == nil) {
        GPBrandDetailSegment *resultSegement = [GPBrandDetailSegment segment];
        resultSegement.showSeperatorLines = YES;
        resultSegement.leftTitle = @"攻略";
        resultSegement.rightTitle = @"礼物";
        resultSegement.frame = CGRectMake(0, 0, TPCScreenW, GPResultSegementH);
        [resultSegement leftButtonAddTarget:self selector:@selector(guideButtonOnClick) forContrlEvents:UIControlEventTouchUpInside];
        [resultSegement rightButtonAddTarget:self selector:@selector(giftButtonOnClick) forContrlEvents:UIControlEventTouchUpInside];
        [self.resultContainerView addSubview:resultSegement];
        _resultSegement = resultSegement;
    }
    
    return _resultSegement;
}


#pragma mark 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupSearchBar];
    
    [self setupHotWordsCollectionView];
    
    [self loadHotWordsData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    
    self.hotWordsCollectionToViewBottomConstraint.constant = keyboardFrame.size.height;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 界面一显示就获取搜索记录
    [self.searchHistory addObjectsFromArray:[GPSaveTool objectForKey:GPSaveKeySearchHistory]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchBar endEditing:YES];
}

- (void)setupNav
{
    self.view.backgroundColor = TPCBackgroundColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 通过这一句，可以让返回按钮重现
//    self.navigationItem.leftBarButtonItem = nil;
}

- (void)setupSearchBar
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.navigationController.navigationBar.gp_height)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-TPCScreenW / 2 + 10, 0, TPCScreenW - 59, containerView.gp_height)];
    searchBar.placeholder = @"搜索礼物、攻略";
    searchBar.delegate = self;
    [searchBar setTintColor:[UIColor blueColor]];
    [searchBar becomeFirstResponder];
    [containerView addSubview:searchBar];
    self.navigationItem.titleView = containerView;
    self.searchBar = searchBar;
    
    // 移除背景色
    for (UIView *subview in searchBar.subviews) {
        if ([subview isKindOfClass:[UIView class]] && subview.subviews.count > 0) {
            [[subview.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
}

- (void)setupHotWordsCollectionView
{
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    layout.minimumInteritemSpacing = GPHotWordsCollectionMargin;
    layout.minimumLineSpacing = GPHotWordsCollectionMargin;
    layout.headerReferenceSize = CGSizeMake(TPCScreenW, GPHotWordReuseHeaderH);
    
    self.hotWordsCollectionView.collectionViewLayout = layout;
    self.hotWordsCollectionView.delegate = self;
    self.hotWordsCollectionView.dataSource = self;
    self.hotWordsCollectionView.backgroundColor = TPCRGBColor(249, 249, 249);
    self.hotWordsCollectionView.contentInset = UIEdgeInsetsMake(0, GPHotWordsCollectionMargin, GPHotWordsCollectionFootertH, GPHotWordsCollectionMargin);
    
    // 注册
    [self.hotWordsCollectionView registerClass:[GPHotWordsCell class] forCellWithReuseIdentifier:reuseItemIdentifier];
    
    [self.hotWordsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GPHotWordsCollectionViewFooter class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterIdentifier];

    [self.hotWordsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GPHotWordsCollectionViewHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
    
    self.resultContainerView.hidden = YES;
}

- (void)loadHotWordsData
{
    [self.manager GET:@"http://api.liwushuo.com/v1/search/hot_words?" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.hotWords = responseObject[@"data"][@"hot_words"];
        // 加载完成，插入到首个位置
        [self.collectionDataArray insertObject:self.hotWords atIndex:0];
        
        self.searchBar.placeholder = responseObject[@"data"][@"placeholder"];
        [self.hotWordsCollectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        TPCLog(@"%@", error);
    }];
}

- (void)setupSearchResultView
{

}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 根据关键词查找数据
    [self searchWithHotWord:searchBar.text];
}

- (void)searchWithHotWord:(NSString *)hotWord
{
    // 存储搜索记录
    if (![self.searchHistory containsObject:hotWord]) {
        [self.searchHistory addObject:hotWord];
        [GPSaveTool setObject:self.searchHistory forKey:GPSaveKeySearchHistory];
    }
    
    // 礼物－攻略segment
    [self resultSegement];
    
    // 添加搜索结果view
    [self setupGuideResultViewWithHotWord:hotWord];
    [self setupGiftResultViewWithHotWord:hotWord];
    self.guideResultView.hidden = NO;
    self.giftResultView.hidden = YES;
    self.resultContainerView.hidden = NO;
    
    // 关闭键盘
    [self.searchBar endEditing:YES];
}

- (void)setupGuideResultViewWithHotWord:(NSString *)hotWord
{
    GPChannelViewController *channelVc = [[GPChannelViewController alloc] init];
    channelVc.dataArrayName = @"posts";
    channelVc.firstPageURLString = [NSString stringWithFormat:@"http://api.liwushuo.com/v1/search/post?keyword=%@&limit=20&offset=0&sort=", [hotWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    channelVc.view.frame = CGRectMake(0, GPResultSegementH, self.resultContainerView.gp_width, self.resultContainerView.gp_height - GPResultSegementH);
    
    [self addChildViewController:channelVc];
    [self.resultContainerView addSubview:channelVc.view];
    
    self.guideResultView = channelVc.view;
}

- (void)setupGiftResultViewWithHotWord:(NSString *)hotWord
{
    GPItemViewController *itemVc = [[GPItemViewController alloc] init];
    itemVc.firstPageURLString = [NSString stringWithFormat:@"http://api.liwushuo.com/v1/search/item?keyword=%@&limit=20&offset=0&sort=", [hotWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    itemVc.view.frame = CGRectMake(0, GPResultSegementH, self.resultContainerView.gp_width, self.resultContainerView.gp_height - GPResultSegementH);
    
    [self addChildViewController:itemVc];
    [self.resultContainerView addSubview:itemVc.view];
    
    self.giftResultView = itemVc.view;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.collectionDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionDataArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GPHotWordsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseItemIdentifier forIndexPath:indexPath];
    
    cell.title = self.collectionDataArray[indexPath.section][indexPath.item];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];

        ((GPHotWordsCollectionViewHeader *)reusableView).title = indexPath.section == 0 ? @"大家都在搜" : @"搜索历史";
    } else {
         reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterIdentifier forIndexPath:indexPath];
        [((GPHotWordsCollectionViewFooter *)reusableView) addTarget:self action:@selector(clearSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    }
    return reusableView;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *hotWord = indexPath.section == 0 ? self.hotWords[indexPath.row] : self.searchHistory[indexPath.row];

    [self searchWithHotWord:hotWord];
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = indexPath.section == 0 ? self.hotWords[indexPath.item] : self.searchHistory[indexPath.item];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : GPHotWordsFont} context:nil];
    CGFloat itemW = rect.size.width + GPHotWordsCellHorizontalMargin * 2;
    CGFloat itemH = rect.size.height + GPHotWordsCellVerticalMargin * 2;
    
    return CGSizeMake(itemW, itemH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
{
    if (section == self.collectionDataArray.count - 1 &&
        [self.collectionDataArray lastObject] == self.searchHistory) {
        return CGSizeMake(TPCScreenW, GPHotWordsCollectionFootertH);
    }
    
    return CGSizeZero;
}

#pragma mark 监听回调
- (void)guideButtonOnClick
{
    self.giftResultView.hidden = YES;
    self.guideResultView.hidden = NO;
}

- (void)giftButtonOnClick
{
    self.giftResultView.hidden = NO;
    self.guideResultView.hidden = YES;
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearSearchHistory
{
    [self.collectionDataArray removeObject:self.searchHistory];
    self.searchHistory = nil;
    [GPSaveTool setObject:self.searchHistory forKey:GPSaveKeySearchHistory];
    [self.hotWordsCollectionView reloadData];
}
@end
