//
//  GPDetailHeader.h
//  礼物说
//
//  Created by heew on 15/1/18.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPSearchGift,GPPageScrollView;
@interface GPDetailHeader : UIView
@property (weak, nonatomic) IBOutlet GPPageScrollView *pageView;
@property (nonatomic, strong) GPSearchGift *gift; /**礼物模型 */
+ (instancetype)detailHeader;
@end
