//
//  GPDetailHeader.m
//  礼物说
//
//  Created by heew on 15/1/18.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPDetailHeader.h"
#import "GPSearchGift.h"
#import "GPPageScrollView.h"

@interface GPDetailHeader ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation GPDetailHeader

- (void)setGift:(GPSearchGift *)gift {
    _gift = gift;
    self.pageView.imageURLStrings = gift.image_urls;
    self.nameLabel.text = gift.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥:%@",gift.price];
    self.descLabel.text = gift.giftDescription;
    
    self.gp_width = TPCScreenW;
    [self layoutIfNeeded];
    self.gift.detailHeaderHeight = CGRectGetMaxY(self.descLabel.frame) + 10;
}

+ (instancetype)detailHeader {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    self.descLabel.preferredMaxLayoutWidth = TPCScreenW - 20;
    self.autoresizingMask = UIViewAutoresizingNone;
}

@end
