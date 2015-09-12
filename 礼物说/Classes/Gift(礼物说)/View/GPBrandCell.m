//
//  GPBrandCell.m
//  礼物说
//
//  Created by tripleCC on 15/1/16.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPBrandCell.h"
#import "GPBrand.h"

@interface GPBrandCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *imageContentView;
@property (weak, nonatomic) IBOutlet UIView *topContentView;
/** 大图 */
@property (weak, nonatomic) UIImageView *bigImageView;

/** 小图数组 */
@property (strong, nonatomic) NSMutableArray *smallImageViews;
@end

static const NSInteger GPImageCount = 5;
static const CGFloat GPBrandCellMargin = 2;

@implementation GPBrandCell

#pragma mark 懒加载
- (NSMutableArray *)smallImageViews
{
    if (_smallImageViews == nil) {
        _smallImageViews = @[].mutableCopy;
    }
    
    return _smallImageViews;
}

#pragma mark 初始化
- (void)awakeFromNib {
    [self createImageView];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)createImageView
{
    // 创建大图
    UIImageView *bigImageView = [[UIImageView alloc] init];
    [self.imageContentView addSubview:bigImageView];
    self.bigImageView = bigImageView;
    
    // 添加小图
    for (NSInteger i = 0; i < GPImageCount - 1; i++) {
        UIImageView *smallImageView = [[UIImageView alloc] init];
        [self.imageContentView addSubview:smallImageView];
        [self.smallImageViews addObject:smallImageView];
    }
}

- (void)setBrand:(GPBrand *)brand
{
    _brand = brand;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:brand.cover_image_url]];
    self.nameLabel.text = brand.name;
    self.descLabel.text = brand.desc;
    
    [self.bigImageView sd_setImageWithURL:[brand.image_urls firstObject]];
    for (NSInteger i = 0; i < GPImageCount - 1; i++) {
        UIImageView *smallImageView = self.smallImageViews[i];
        
        [smallImageView sd_setImageWithURL:[NSURL URLWithString:brand.image_urls[i + 1]]];
    }
    
}

#pragma mark 布局相关
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置四周边距
    // 这种方式不知道为什么后来会使layoutSubviews一直调用，所以不使用
//    self.contentView.x = TPCTableViewCellUIEdgeInsets.left;
//    self.contentView.gp_height -= TPCTableViewCellUIEdgeInsets.bottom;
//    self.contentView.gp_width -= TPCTableViewCellUIEdgeInsets.right + TPCTableViewCellUIEdgeInsets.left;
    
    // 设置放置图片控件的大小
    CGFloat imageContentViewW = self.contentView.gp_width - 2 * (TPCTableViewCellUIEdgeInsets.left - GPBrandCellMargin) - (TPCTableViewCellUIEdgeInsets.right + TPCTableViewCellUIEdgeInsets.left);
    CGFloat imageContentViewH = self.contentView.gp_height - CGRectGetMaxY(self.topContentView.frame) - TPCTableViewCellUIEdgeInsets.top * 2 - TPCTableViewCellUIEdgeInsets.bottom;
    self.imageContentView.size = CGSizeMake(imageContentViewW, imageContentViewH);
    
    // 设置大图片
    CGFloat bigImageViewX = self.imageContentView.gp_width * 0.5;
    CGFloat smallImageViewOriginX = 0;
    if (self.isBigImageViewLeft) {
        smallImageViewOriginX = bigImageViewX;
        bigImageViewX = 0;
    }
    
    self.bigImageView.frame = CGRectMake(bigImageViewX, 0, self.imageContentView.gp_width * 0.5, self.imageContentView.gp_height);
    [self setupImageViewMargin:self.bigImageView];
    
    // 设置小图片
    NSInteger columns = 2;
    CGFloat smallImageViewW = self.imageContentView.gp_width * 0.5 * 0.5;
    CGFloat smallImageViewH = self.imageContentView.gp_height * 0.5;
    CGFloat smallImageViewY = 0;
    CGFloat smallImageViewX = 0;
    for (NSInteger i = 0; i < self.smallImageViews.count; i++) {
        UIImageView *smallImageView = self.smallImageViews[i];
        smallImageViewY = i / columns * smallImageViewH;
        smallImageViewX = i % columns * smallImageViewW + smallImageViewOriginX;
        smallImageView.frame = CGRectMake(smallImageViewX, smallImageViewY, smallImageViewW, smallImageViewH);
        [self setupImageViewMargin:smallImageView];
    }
}

- (void)setupImageViewMargin:(UIImageView *)imageView
{
    imageView.x += GPBrandCellMargin;
    imageView.gp_width -= 2 * GPBrandCellMargin;
    imageView.y += GPBrandCellMargin;
    imageView.gp_height -= 2 * GPBrandCellMargin;
}
@end
