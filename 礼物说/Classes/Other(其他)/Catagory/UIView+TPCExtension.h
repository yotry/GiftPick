//
//  UIView+TPCFrame.h
//  礼物说
//
//  Created by tripleCC on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TPCExtension)

@property (assign, nonatomic) CGFloat gp_width;

@property (assign, nonatomic) CGFloat gp_height;

@property (assign, nonatomic) CGFloat x;

@property (assign, nonatomic) CGFloat y;

@property (assign, nonatomic) CGFloat gp_centerX;

@property (assign, nonatomic) CGFloat gp_centerY;

@property (assign, nonatomic) CGSize size;

- (BOOL)isShowingOnKeyWindow;

+ (instancetype)viewWithNib;
@end
