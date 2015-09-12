//
//  TPCEditChannelView.h
//  礼物说
//
//  Created by tripleCC on 15/1/10.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TPCChannelType) {
    TPCChannelTypeFood,         // 美食
    TPCChannelTypeGift,         // 礼物
    TPCChannelTypeSports,       // 运动
    TPCChannelTypeChoiceness,   // 精选
    TPCChannelTypeEntertainment,// 娱乐
    TPCChannelTypeDigitalProduct// 数码
};

@class GPEditChannelView;
@protocol TPCEditChannelViewDelegate <NSObject>

- (void)editChannelView:(GPEditChannelView *)editChannelView didClickChannelAtIndex:(NSUInteger)index;

@end

@interface GPEditChannelView : UIView
- (void)switchToNormalMode;
- (void)switchToDeleteMode;
@end
