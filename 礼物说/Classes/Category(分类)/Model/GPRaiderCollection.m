//
//  GPRaiderCollection.m
//  礼物说
//
//  Created by heew on 15/1/23.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPRaiderCollection.h"

@implementation GPRaiderCollection

-(void)setBanner_image_url:(NSString *)banner_image_url {
    NSMutableString *str = [NSMutableString stringWithString:banner_image_url];
    NSRange range = [str rangeOfString:@"-w300"];
    [str deleteCharactersInRange:range];
    _banner_image_url = str;
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}
@end
