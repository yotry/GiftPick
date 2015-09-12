//
//  GPBrandDetailHeadImageView.m
//  礼物说
//
//  Created by tripleCC on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPBrandDetailHeadImageView.h"
#import "GPBrandDetail.h"

@interface GPBrandDetailHeadImageView()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *brandIconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end

@implementation GPBrandDetailHeadImageView

+ (instancetype)headImageView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.brandIconImage.layer.cornerRadius = self.brandIconImage.gp_width * 0.5;
    self.brandIconImage.clipsToBounds = YES;
}

- (void)setBrandDetail:(GPBrandDetail *)brandDetail
{
    _brandDetail = brandDetail;
    
    self.titleLabel.text = brandDetail.name;
    self.detailLabel.text = brandDetail.desc;
    [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:brandDetail.cover_image_url]];
    [self.brandIconImage sd_setImageWithURL:[NSURL URLWithString:brandDetail.icon_url]];
}
@end
