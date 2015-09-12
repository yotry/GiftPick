//
//  TPCGiftBaceViewController.h
//  礼物说
//
//  Created by tripleCC on 15/1/9.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPChannelViewController : UITableViewController
/** 第一页URL */
@property (copy, nonatomic) NSString *firstPageURLString;

/** JSON中的数据数组名 */
@property (strong, nonatomic) NSString *dataArrayName;

/** cell背景颜色 */
@property (strong, nonatomic) UIColor *cellBackgroundColor;

@end
