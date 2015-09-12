//
//  GPSubCategoryCell.m
//  礼物说
//
//  Created by heew on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPSubCategoryCell.h"
#import "GPSubCategory.h"


@interface GPSubCategoryCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation GPSubCategoryCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    GPSubCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:subCategoryIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)setSubCategory:(GPSubCategory *)subCategory {
    _subCategory = subCategory;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:subCategory.icon_url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = subCategory.name;
}


@end
