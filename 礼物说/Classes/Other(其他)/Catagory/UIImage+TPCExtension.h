//
//  UIImage+TPCExtension.h
//  百思不得姐
//
//  Created by tripleCC on 15/1/4.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TPCExtension)
- (UIImage *)headerImageWithRandomBorderColor;
- (UIImage *)headerImageWithBorderColor:(UIColor *)color;
- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)imageWithRoundClipImage:(UIImage *)image borderColor:(UIColor *)color borderWidth:(CGFloat)width;
@end
