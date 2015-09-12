//
//  GPItemCell.m
//  礼物说
//
//  Created by heew on 15/1/16.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPSearchGiftCell.h"
#import "GPSearchGift.h"

static NSString * const reuseIdentifier = @"searchGift";
@interface GPSearchGiftCell ()
@property (weak, nonatomic) IBOutlet UIImageView *giftImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteView;

@end

@implementation GPSearchGiftCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    GPSearchGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)awakeFromNib {
    [self.nameLabel sizeToFit];
}

- (void)setGift:(GPSearchGift *)gift {
    [self.giftImage sd_setImageWithURL:[NSURL URLWithString:gift.cover_image_url] placeholderImage:[UIImage imageNamed:@"searchGift_placeHolder"]];
    self.nameLabel.text = gift.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@",gift.price];
    [self.favoriteView setTitle:gift.favorites_count forState:UIControlStateNormal];
}

@end
