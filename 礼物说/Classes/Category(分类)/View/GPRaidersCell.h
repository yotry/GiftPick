//
//  GPChannelCell.h
//  礼物说
//
//  Created by heew on 15/1/20.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPChannel;
static NSString * const reuseIdentifier = @"channelGroup";
@interface GPRaidersCell : UICollectionViewCell
@property (nonatomic, strong) GPChannel *channel; /**分类攻略 */

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@end
