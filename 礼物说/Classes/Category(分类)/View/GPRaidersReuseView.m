//
//  GPChannelReuseView.m
//  礼物说
//
//  Created by heew on 15/1/20.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPRaidersReuseView.h"
#import "GPChannelGroup.h"


@interface GPRaidersReuseView ()
@property (weak, nonatomic) IBOutlet UILabel *channelTitleLabel;

@end

@implementation GPRaidersReuseView

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)reuseViewWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    
    GPRaidersReuseView *reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
    return reuseView;
}

- (void)setChannelGroup:(GPChannelGroup *)channelGroup {
    _channelGroup = channelGroup;
    self.channelTitleLabel.text =channelGroup.name;
}
@end
