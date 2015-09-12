//
//  GPChannelCell.m
//  礼物说
//
//  Created by heew on 15/1/20.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPRaidersCell.h"
#import "GPChannel.h"


@interface GPRaidersCell () 
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation GPRaidersCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    GPRaidersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setChannel:(GPChannel *)channel {
    _channel = channel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:channel.icon_url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = channel.name;
}

@end
