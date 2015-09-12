//
//  TPCButton.h
//  礼物说
//
//  Created by tripleCC on 15/1/15.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface TPCButton : UIButton

/** 边框圆角半径 */
@property (assign, nonatomic) CGFloat cornerBoarderRadius;

/** 边框颜色 */
@property (strong, nonatomic) UIColor *cornerBoarderColor;

/** 圆角按钮背景颜色 */
@property (strong, nonatomic) UIColor *cornerBackgroundColor;
@end
