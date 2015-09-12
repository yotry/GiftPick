//
//  GPBrandDetailSegment.h
//  礼物说
//
//  Created by tripleCC on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPBrandDetailSegment : UIView
@property (copy, nonatomic) NSString *leftTitle;
@property (copy, nonatomic) NSString *rightTitle;
@property (assign, nonatomic, getter=isShowSeperatorLines) BOOL showSeperatorLines;
+ (instancetype)segment;

- (void)leftButtonAddTarget:(id) target selector:(SEL)action forContrlEvents:(UIControlEvents)controlEvents;
- (void)rightButtonAddTarget:(id) target selector:(SEL)action forContrlEvents:(UIControlEvents)controlEvents;
@end
