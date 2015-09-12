//
//  UIImage+TPCExtension.m
//  百思不得姐
//
//  Created by tripleCC on 15/1/4.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "UIImage+TPCExtension.h"

@implementation UIImage (GPExtension)

- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius
{
    UIGraphicsBeginImageContext(self.size);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(cornerRadius, 1)];
    [path addLineToPoint:CGPointMake(self.size.width - cornerRadius - 1, 1)];
    [path addArcWithCenter:CGPointMake(self.size.width - cornerRadius  - 1, cornerRadius + 1) radius:cornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.size.width - 1, self.size.height - cornerRadius - 1)];
    [path addArcWithCenter:CGPointMake(self.size.width - cornerRadius  - 1, self.size.height - cornerRadius  - 1) radius:cornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(cornerRadius, self.size.height - 1)];
    [path addArcWithCenter:CGPointMake(cornerRadius + 1, self.size.height - cornerRadius  - 1) radius:cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(1, cornerRadius + 1)];
    [path addArcWithCenter:CGPointMake(cornerRadius + 1, cornerRadius + 1) radius:cornerRadius startAngle:M_PI endAngle:M_PI * 1.5 clockwise:YES];
    
    [path addClip];
    [path stroke];

    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithRoundClipImage:(UIImage *)image borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    // 后面大圆的rect
    CGRect bigOvalRect = CGRectMake(0, 0, imageW + 2 * width, imageH + 2 * width);
    // 前面小圆的rect
    CGRect smallOvalRect = CGRectMake(width, width, imageW, imageH);
    // 上下文尺寸
    CGSize contextSize = CGSizeMake(imageW + 2 * width, imageH + 2 * width);
    
    UIGraphicsBeginImageContext(contextSize);
    
    // 渲染填充大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:bigOvalRect];
    [color set];
    [path fill];
    
    // 渲染裁剪小圆
    path = [UIBezierPath bezierPathWithOvalInRect:smallOvalRect];
    [path addClip];
    [path stroke];
    
    // 绘制获取图片
    [image drawInRect:CGRectMake(width, width, image.size.width, image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)headerImageWithRandomBorderColor
{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIImage imageWithRoundClipImage:self borderColor:[UIColor colorWithRed:r green:g blue:b alpha:1.0] borderWidth:2.0];
}

- (UIImage *)headerImageWithBorderColor:(UIColor *)color
{
    return [UIImage imageWithRoundClipImage:self borderColor:color borderWidth:2.0];
}

@end
