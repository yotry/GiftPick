//
//  TPCChannelButton.h
//  礼物说
//
//  Created by tripleCC on 15/1/11.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPCButton.h"

@class GPChannelButton;

@interface GPChannelButton : TPCButton
/** 点击删除按钮后的操作 */
@property (copy, nonatomic) void (^deleteOperate)(GPChannelButton *btn);

/** 隐藏删除按钮 */
@property (assign, nonatomic, getter=isHideDeleteButton) BOOL hideDeleteButton;

/** 替换执行的动作 */
- (void)replaceActionFromAction:(SEL)from toAction:(SEL)to forControlEvents:(UIControlEvents)controlEvents;
@end
