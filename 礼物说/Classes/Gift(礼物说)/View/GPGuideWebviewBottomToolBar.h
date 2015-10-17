//
//  GPGuideWebviewBottomToolBar.h
//  礼物说
//
//  Created by tripleCC on 15/1/20.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPGuideWebviewBottomToolBar : UIView
+ (instancetype)guideWebviewBottomToolBar;
- (void)addLikeButtonTarget:(id)target action:(SEL)action;
- (void)addShareButtonTarget:(id)target action:(SEL)action;
- (void)addCommentButtonTarget:(id)target action:(SEL)action;
@end
