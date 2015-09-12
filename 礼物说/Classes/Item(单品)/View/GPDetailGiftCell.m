//
//  GPDetailGiftCell.m
//  礼物说
//
//  Created by heew on 15/1/19.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPDetailGiftCell.h"
#import "GPGiftComment.h"

@interface GPDetailGiftCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation GPDetailGiftCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    GPDetailGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setComment:(GPGiftComment *)comment
{
    _comment = comment;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:comment.avatar_url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = comment.nickname;
    self.commentLabel.text = comment.content;
    self.timeLabel.text = comment.created_at;
}
- (void)awakeFromNib {
    self.iconView.layer.cornerRadius = self.iconView.gp_width * 0.5;
    self.iconView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
