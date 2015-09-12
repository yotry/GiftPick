//
//  GPSearchGift.m
//  礼物说
//
//  Created by heew on 15/1/16.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPSearchGift.h"

@implementation GPSearchGift
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"giftDescription": @"description",
             @"ID" : @"id"
             };
}
@end
