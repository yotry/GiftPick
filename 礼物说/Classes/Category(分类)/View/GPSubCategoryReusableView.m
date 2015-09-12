//
//  GPSubCategoryReusableView.m
//  礼物说
//
//  Created by heew on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPSubCategoryReusableView.h"
#import "GPCategory.h"


@interface GPSubCategoryReusableView ()
@property (weak, nonatomic) IBOutlet UILabel *channelTitleLabel;

@end
@implementation GPSubCategoryReusableView

+ (instancetype)reuseViewWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    
    GPSubCategoryReusableView *reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
    return reuseView;
}

- (void)setCatetory:(GPCategory *)catetory {
    _catetory = catetory;
    self.channelTitleLabel.text =catetory.name;
}

@end
