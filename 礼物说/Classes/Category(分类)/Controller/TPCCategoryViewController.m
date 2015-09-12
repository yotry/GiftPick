//
//  TPCCategoryViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/8.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "TPCCategoryViewController.h"
#import "TPCRaidersController.h"
#import "TPCGiftController.h"
#import "GPSearchViewController.h"

@interface TPCCategoryViewController ()
@property (nonatomic, weak) TPCRaidersController *raiderVc; /**攻略控制器 */
@property (nonatomic, weak) TPCGiftController *giftVc; /**礼物控制器 */
@end

@implementation TPCCategoryViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildControllers];
    
    [self setupNavigationBar];
}

- (void)setupChildControllers {
    TPCRaidersController *raiderVc = [[TPCRaidersController alloc] init];
    [self addChildViewController:raiderVc];
    self.raiderVc = raiderVc;
    
    TPCGiftController *giftVc = [[TPCGiftController alloc] init];
    [self addChildViewController:giftVc];
    self.giftVc = giftVc;
}

- (void)setupNavigationBar {
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"攻略",@"礼物"]];
    segment.tintColor = [UIColor whiteColor];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = TPCThemeColor;
    [segment setTitleTextAttributes:attr forState:UIControlStateSelected];
    segment.gp_width += 100;
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    segment.selectedSegmentIndex = 0;
    [self segmentClick:segment];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"find"] style:UIBarButtonItemStyleDone target:self action:@selector(search)];
}

- (void)search{
    GPSearchViewController *searchVc = [[GPSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (void)segmentClick:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        [self.view addSubview:self.raiderVc.view];
        self.raiderVc.view.frame = self.view.bounds;
    } else {
        [self.view addSubview:self.giftVc.view];
        self.giftVc.view.frame = self.view.bounds;
    }
}
@end
