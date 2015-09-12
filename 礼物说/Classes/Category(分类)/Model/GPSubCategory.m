//
//  GPSubCategory.m
//  礼物说
//
//  Created by heew on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPSubCategory.h"

@implementation GPSubCategory
- (void)setIcon_url:(NSString *)icon_url {
    NSMutableString *str = [NSMutableString stringWithString:icon_url];
    NSRange range = [str rangeOfString:@"-pw144"];
    [str deleteCharactersInRange:range];
    _icon_url = str;
}


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}
@end
