//
//  GPRaiderHeaderView.h
//  礼物说
//
//  Created by heew on 15/1/23.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPRaiderCollection;
@protocol RaiderHeaderViewDelegate <NSObject>

@optional
- (void)raiderHeaderViewDidClickWithCollection:(GPRaiderCollection *)collection;

@end

@interface GPRaiderHeaderView : UIView
@property (nonatomic, strong) NSArray *collections; /**模型数组 */
@property (nonatomic, weak) id <RaiderHeaderViewDelegate> delegate; /**代理 */
+ (instancetype)raiderHeaderView;

@end


@interface RaiderHeaderImageView : UIImageView
@property (nonatomic, strong) GPRaiderCollection *collection; /**模型 */
@end