//
//  GPItemCell.h
//  礼物说
//
//  Created by heew on 15/1/16.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPSearchGift;
@interface GPSearchGiftCell : UICollectionViewCell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) GPSearchGift *gift; /**礼物模型 */
@end
