//
//  TPCItemCell.m
//  礼物说
//
//  Created by tripleCC on 15/1/14.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPFeedPostCell.h"

@interface GPFeedPostCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *likesCountButton;
@end

@implementation GPFeedPostCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupLabelShadow];
}

- (void)setupLabelShadow
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    gradientLayer.opacity  = 0.6;
    gradientLayer.frame = CGRectMake(0, 0, TPCScreenW - TPCTableViewCellUIEdgeInsets.right - TPCTableViewCellUIEdgeInsets.left, self.titleLabel.superview.gp_height);
    [self.titleLabel.superview.layer insertSublayer:gradientLayer below:self.titleLabel.layer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (IBAction)likesCountButtonOnClick:(UIButton *)sender {
    NSLog(@"%s", __func__);
}


- (void)setItem:(GPItem *)item
{
    self.titleLabel.text = item.title;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:item.cover_image_url]];
        // 设置了圆角之后，下面的会被阴影层挡住
//        [self.coverImageButton setBackgroundImage:[image imageWithCornerRadius:10.0] forState:UIControlStateNormal];

#warning 设置喜欢按钮
    
    [self.likesCountButton setTitle:[NSString stringWithFormat:@"%ld", item.likes_count] forState:UIControlStateNormal];
}

@end
