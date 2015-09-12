//
//  TPCGiftViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/8.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPGiftViewController.h"
#import "GPChannelViewController.h"
#import "GPChoicenessViewController.h"
#import "GPEditChannelView.h"
#import "GPSearchViewController.h"

// 标签按钮最大可见数
static const CGFloat TPCLabelButtonMaxVisibleCount = 5;

@interface GPGiftViewController () <UIScrollViewDelegate>
// 标签scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *channelScrollView;
// 内容
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

// 编辑标签模式头视图
@property (weak, nonatomic) IBOutlet UIView *editChannelTitleView;

/** 底部索引控件 */
@property (weak, nonatomic) UIView *indicatorView;

/** 选中的按钮 */
@property (weak, nonatomic) UIButton *disabledButton;

/** 标签按钮 */
@property (strong, nonatomic) NSMutableArray *channelButtons;

/** 切换编辑模式按钮(排序或删除) */
@property (weak, nonatomic) IBOutlet UIButton *switchEditModeButton;

// 切换频道提示Label
@property (weak, nonatomic) IBOutlet UILabel *switchEditModeTipLabel;

/** 编辑频道内容 */
@property (weak, nonatomic) GPEditChannelView *editChannelView;
@end

@implementation GPGiftViewController
#pragma mark 懒加载
- (NSMutableArray *)channelButtons
{
    if (_channelButtons == nil) {
        _channelButtons = @[].mutableCopy;
    }
    
    return _channelButtons;
}

- (GPEditChannelView *)editChannelView
{
    if (_editChannelView == nil) {
        GPEditChannelView *editChannelView = [[GPEditChannelView alloc] init];
        editChannelView.x = 0;
        editChannelView.y = 64 + 35;
        editChannelView.gp_width = TPCScreenW;
        editChannelView.gp_height = TPCScreenH - editChannelView.y;
        editChannelView.backgroundColor = TPCRGBColor(249, 249, 249);
        [self.view insertSubview:editChannelView aboveSubview:self.contentScrollView];
        _editChannelView = editChannelView;

        _editChannelView.transform = CGAffineTransformMakeTranslation(0, -self.editChannelView.gp_height);
    }
    
    return _editChannelView;
}

#pragma mark 初始化
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNav];
    
    [self setupChildController];
    
    [self setupChannelButtons];
    
    [self setupContentScrollView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self setupChannelButtonsFrame];
}

- (void)setupContentScrollView
{
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * TPCScreenW, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}

- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"] style:UIBarButtonItemStyleDone target:self action:@selector(scanQRCode)];
    
    NSMutableArray *barButtonItems = [NSMutableArray array];
    UIBarButtonItem *findItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"find"] style:UIBarButtonItemStyleDone target:self action:@selector(findGift)];
    [barButtonItems addObject:findItem];
#warning 这里可以插入夜间模式
    self.navigationItem.rightBarButtonItems = barButtonItems;
}

- (void)setupChildController
{
    NSString *dataArrayName = @"items";
    
    GPChoicenessViewController *choicenessVc = [[GPChoicenessViewController alloc] init];
    choicenessVc.cellBackgroundColor = [UIColor whiteColor];
    [self setupOneChildViewController:choicenessVc
                            withTitle:@"精选"
                   firstPageURLString:[self channelURLWithNumber:100]
                        dataArrayName:dataArrayName];
    
    [self setupOneChildViewController:[[GPChannelViewController alloc] init]
                            withTitle:@"数码"
                   firstPageURLString:[self channelURLWithNumber:121]
                        dataArrayName:dataArrayName];

    [self setupOneChildViewController:[[GPChannelViewController alloc] init]
                            withTitle:@"运动"
                   firstPageURLString:[self channelURLWithNumber:123]
                        dataArrayName:dataArrayName];
    
    [self setupOneChildViewController:[[GPChannelViewController alloc] init]
                            withTitle:@"娱乐"
                   firstPageURLString:[self channelURLWithNumber:120]
                        dataArrayName:dataArrayName];
    
    [self setupOneChildViewController:[[GPChannelViewController alloc] init]
                            withTitle:@"美食"
                   firstPageURLString:[self channelURLWithNumber:118]
                        dataArrayName:dataArrayName];
    
    [self setupOneChildViewController:[[GPChannelViewController alloc] init]
                            withTitle:@"礼物"
                   firstPageURLString:[self channelURLWithNumber:111]
                        dataArrayName:dataArrayName];
}

- (void)setupOneChildViewController:(GPChannelViewController *)vc withTitle:(NSString *)title firstPageURLString:(NSString *)firstPageURLString dataArrayName:(NSString *)dataArrayName
{
    vc.title = title;
    vc.dataArrayName = dataArrayName;
    vc.firstPageURLString = firstPageURLString;
    [self addChildViewController:vc];
}

- (NSString *)channelURLWithNumber:(NSInteger)number
{
    NSMutableString *channelURL = [NSMutableString stringWithString:@"http://api.liwushuo.com/v1/channels/"];
    [channelURL appendFormat:@"%ld", number];
    [channelURL appendString:@"/items?limit=20&offset=0"];

    return channelURL;
}

// 设置标签
- (void)setupChannelButtons
{
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = TPCThemeColor;
    [self.channelScrollView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:TPCTitleGrayColor forState:UIControlStateNormal];
        [button setTitleColor:TPCThemeColor forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(channelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[self.childViewControllers[i] title] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self.channelScrollView addSubview:button];
        [self.channelButtons addObject:button];
        // 设置默认选中按钮
        if (i == 0) {
            button.enabled = NO;
            self.disabledButton = button;
        }
    }
}

- (void)channelButtonClick:(UIButton *)button
{
    // 设置内容偏移，由内容来决频道标题
    CGFloat contentOffsetX = button.x / button.gp_width * self.contentScrollView.gp_width;;
    [self.contentScrollView setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSUInteger channelIndex = scrollView.contentOffset.x / scrollView.gp_width;
    UIButton *channelButton = self.channelButtons[channelIndex];
    
    // 设置频道偏移量
    CGFloat channelOffsetX = channelButton.gp_centerX - self.channelScrollView.gp_width * 0.5;
    channelOffsetX = MIN(MAX(0, channelOffsetX), self.channelScrollView.contentSize.width - self.channelScrollView.gp_width);
    [self.channelScrollView setContentOffset:CGPointMake(channelOffsetX, 0) animated:YES];
    
    [self setDisableChannelButton:channelButton];
    [self loadControllerViewByIndex:channelIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)setupChannelButtonsFrame
{
    // 设置索引控件坐标
    self.indicatorView.gp_height = 2.5;
    self.indicatorView.y = self.channelScrollView.gp_height - self.indicatorView.gp_height;
    
    CGFloat buttonW = self.channelScrollView.gp_width / TPCLabelButtonMaxVisibleCount;
    CGFloat buttonH = self.channelScrollView.gp_height;
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        // 设置标签按钮坐标
        UIButton *button = self.channelButtons[i];
        button.gp_height = buttonH;
        button.gp_width = buttonW;
        button.x = i * buttonW;
        
        if (i == 0 && self.disabledButton == button) {
            [button.titleLabel sizeToFit];
            self.indicatorView.gp_width = button.titleLabel.gp_width;
            self.indicatorView.gp_centerX = button.gp_centerX;
        }
    }
    
    // 因为上面被按钮覆盖了，所以不需要手动滑动，但是要求点击能让点击的频道标签剧终
    self.channelScrollView.contentSize = CGSizeMake(self.channelButtons.count * buttonW, 0);
}

- (void)loadControllerViewByIndex:(NSUInteger)index
{
    UIViewController *showingVc = self.childViewControllers[index];
    // 如果控制器view已经被加载，就没有必要重新设置一次frame
    if ([showingVc isViewLoaded]) return;
    
    showingVc.view.frame = CGRectMake(index * self.contentScrollView.gp_width, 0, self.contentScrollView.gp_width, self.contentScrollView.gp_height);
    [self.contentScrollView addSubview:showingVc.view];
}

- (void)setDisableChannelButton:(UIButton *)channelButton
{
    self.disabledButton.enabled = YES;
    self.disabledButton = channelButton;
    self.disabledButton.enabled = NO;
    
    // 底部提示下划线移动
    [UIView animateWithDuration:0.2 animations:^{
        self.indicatorView.gp_centerX = channelButton.gp_centerX;
        self.indicatorView.gp_width = channelButton.titleLabel.gp_width;
    }];
}

// 查找礼物
- (void)findGift
{
    GPSearchViewController *searchVc = [[GPSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:YES];
}

// 扫描二维码
- (void)scanQRCode
{
    
}

// 编辑标签模式
- (IBAction)editChannelsMode:(UIButton *)sender {
    // 先创建，防止动画显示不正常
    [self editChannelView];
    BOOL isSelected = sender.isSelected;
    
    [UIView animateWithDuration:0.4 animations:^{
        sender.imageView.transform = CGAffineTransformRotate(sender.imageView.transform, M_PI);
        if (isSelected) {
            self.editChannelView.transform = CGAffineTransformMakeTranslation(0, -self.editChannelView.gp_height);
        } else {
            self.editChannelView.transform = CGAffineTransformIdentity;
        }
        self.editChannelTitleView.alpha = !self.editChannelTitleView.alpha;
    } completion:^(BOOL finished) {
        if (isSelected) {
            // 删除频道编辑视图
            [self.editChannelView removeFromSuperview];
            self.editChannelView = nil;
            
            // 初始化模式切换选中状态
            self.switchEditModeButton.selected = NO;
        }
    }];

    // 切换到正常模式
    [self.editChannelView switchToNormalMode];
    sender.selected = !sender.selected;
}

// 模式切换（排序或删除--完成）
- (IBAction)switchEditMode:(UIButton *)sender {
    if (sender.isSelected) {
        [self.editChannelView switchToNormalMode];
        self.switchEditModeTipLabel.text = @"切换频道";
    } else {
        [self.editChannelView switchToDeleteMode];
        self.switchEditModeTipLabel.text = @"拖动排序";
    }
    sender.selected = !sender.selected;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
