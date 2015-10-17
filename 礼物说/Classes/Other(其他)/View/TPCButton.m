//
//  TPCButton.m
//  礼物说
//
//  Created by tripleCC on 15/1/15.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "TPCButton.h"

@implementation TPCButton

- (void)setCornerBackgroundColor:(UIColor *)cornerBackgroundColor
{
    _cornerBackgroundColor = cornerBackgroundColor;
    
    [self setNeedsDisplay];
}

- (void)setCornerBoarderColor:(UIColor *)cornerBoarderColor
{
    _cornerBoarderColor = cornerBoarderColor;
    
    [self setNeedsDisplay];
}

- (void)setCornerBoarderRadius:(CGFloat)cornerBoarderRadius
{
    _cornerBoarderRadius = cornerBoarderRadius;
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 每次改变frame都需要刷新
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.cornerBackgroundColor) {
        // 填充圆角背景颜色
        [self.cornerBackgroundColor set];
        [[self pathWithCornerRadius:self.cornerBoarderRadius] fill];
    }
    
    if (self.cornerBoarderRadius) {
        // 绘制圆角边框
        [self.cornerBoarderColor set];
        [[self pathWithCornerRadius:self.cornerBoarderRadius] stroke];
    }
    
    if (self.isDrawUnderLine) {
        [self drawUnderLine:rect];
    }
}

- (void)drawUnderLine:(CGRect)rect
{
    CGFloat buttonH = rect.size.height;
    CGFloat buttonW = rect.size.width;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 0, buttonH);
    CGContextAddLineToPoint(context, buttonW, buttonH);
    
    [self.titleLabel.textColor set];
    CGContextStrokePath(context);
}

- (UIBezierPath *)pathWithCornerRadius:(CGFloat)cornerRadius
{
    CGFloat buttonH = self.gp_height;
    CGFloat buttonW = self.gp_width;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(cornerRadius, 1)];
    [path addLineToPoint:CGPointMake(buttonW - cornerRadius - 1, 1)];
    [path addArcWithCenter:CGPointMake(buttonW - cornerRadius  - 1, cornerRadius + 1) radius:cornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(buttonW - 1, buttonH - cornerRadius - 1)];
    [path addArcWithCenter:CGPointMake(buttonW - cornerRadius  - 1, buttonH - cornerRadius  - 1) radius:cornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(cornerRadius, buttonH - 1)];
    [path addArcWithCenter:CGPointMake(cornerRadius + 1, buttonH - cornerRadius  - 1) radius:cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(1, cornerRadius + 1)];
    [path addArcWithCenter:CGPointMake(cornerRadius + 1, cornerRadius + 1) radius:cornerRadius startAngle:M_PI endAngle:M_PI * 1.5 clockwise:YES];
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    
    return path;
}
@end
