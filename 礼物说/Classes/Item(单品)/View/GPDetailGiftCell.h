//
//  GPDetailGiftCell.h
//  礼物说
//
//  Created by heew on 15/1/19.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPGiftComment;
@interface GPDetailGiftCell : UITableViewCell
@property (nonatomic, strong) GPGiftComment *comment; /**礼物评论模型 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
