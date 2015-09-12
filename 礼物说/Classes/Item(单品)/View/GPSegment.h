//
//  GPSegment.h
//  礼物说
//
//  Created by heew on 15/1/18.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPSearchGift;

@interface GPSegment : UIView

@property (nonatomic, strong) GPSearchGift *gift; /**礼物模型 */
+ (instancetype)segment;
- (void)descButtonAddTarget:(id) target selector:(SEL)action forContrlEvents:(UIControlEvents)controlEvents;
- (void)commentButtonAddTarget:(id) target selector:(SEL)action forContrlEvents:(UIControlEvents)controlEvents;
@end
