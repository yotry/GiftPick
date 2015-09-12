//
//  GPChannelReuseView.h
//  礼物说
//
//  Created by heew on 15/1/20.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPChannelGroup;
static NSString * const reuseHeaderIdentifier = @"channelHeader";
@interface GPRaidersReuseView : UICollectionReusableView

@property (nonatomic, strong) GPChannelGroup *channelGroup; /**分类攻略 */

+ (instancetype)reuseViewWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@end
