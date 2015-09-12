//
//  TPCChoicenessViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/9.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPChoicenessViewController.h"
#import "GPChoicenessHeaderView.h"
#import "GPItemGroupHeaderView.h"
#import "GPFeedPostCell.h"
#import "GPItem.h"

@interface GPChoicenessViewController ()

/** 头控件 */
@property (weak, nonatomic) GPChoicenessHeaderView *choicenessHeaderView;

@end

@implementation GPChoicenessViewController


#pragma mark 初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableHeaderView];
    
    [self setupTableViewContentInsets];
}

- (void)setupTableHeaderView
{
    // 直接添加到tableView的header会有问题，需要有一个容器
    GPChoicenessHeaderView *header = [GPChoicenessHeaderView header];
    self.choicenessHeaderView = header;
    UIView *containerView = [[UIView alloc] initWithFrame:header.frame];
    containerView.gp_height += TPCTableViewGroupMargin;
    [containerView addSubview:header];
    self.tableView.tableHeaderView = containerView;
}

- (void)setupTableViewContentInsets
{
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top = 0;
    self.tableView.contentInset = insets;
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
