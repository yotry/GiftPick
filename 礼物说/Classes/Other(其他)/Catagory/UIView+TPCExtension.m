//
//  UIView+TPCFrame.m
//  礼物说
//
//  Created by tripleCC on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "UIView+TPCExtension.h"

@implementation UIView (TPCExtension)

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setGp_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    
    self.frame = frame;
}

- (CGFloat)gp_width
{
    return self.frame.size.width;
}


- (void)setGp_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    
    self.frame = frame;
}

- (CGFloat)gp_height
{
    return self.frame.size.height;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}
- (void)setGp_centerX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    
    self.center = center;
}

- (CGFloat)gp_centerX
{
    return self.center.x;
}

- (void)setGp_centerY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    
    self.center = center;
}

- (CGFloat)gp_centerY
{
    return self.center.y;
}

- (BOOL)isShowingOnKeyWindow
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
//    CGRect newFrame =  [keyWindow convertRect:self.frame fromView:self.superview];
    // 从superview转换到keyWindow
    CGRect newFrame = [self.superview convertRect:self.frame toView:keyWindow];
    CGRect winFrame = keyWindow.bounds;
    
    BOOL isInWindow = CGRectIntersectsRect(newFrame, winFrame);
    
    return isInWindow && self.alpha > 0.01 && !self.hidden && self.window == keyWindow;
}

+ (instancetype)viewWithNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
