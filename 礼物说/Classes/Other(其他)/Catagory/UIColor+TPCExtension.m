//
//  UIColor+TPCExtension.m
//  礼物说
//
//  Created by tripleCC on 15/1/13.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "UIColor+TPCExtension.h"

@implementation UIColor (TPCExtension)
+ (UIColor *) colorWithHexString:(NSString *)hexString
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) return [UIColor blackColor];
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6 && [cString length] != 8) return [UIColor blackColor];
    CGFloat alpha = 1.0f;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    if (cString.length == 8) {
        range.location = 6;
        NSString *aString = [cString substringWithRange:range];
        
        unsigned int a;
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        alpha = (CGFloat) a / 255.0f;
    }
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((CGFloat) r / 255.0f)
                           green:((CGFloat) g / 255.0f)
                            blue:((CGFloat) b / 255.0f)
                           alpha:alpha];
}
@end
