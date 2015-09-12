//
//  GPGiftComment.m
//  礼物说
//
//  Created by heew on 15/1/19.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPGiftComment.h"

@implementation GPGiftComment
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"avatar_url" : @"user.avatar_url",
             @"nickname" : @"user.nickname"};
}
- (void)setCreated_at:(NSString *)created_at {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *createDate = [NSDate dateWithTimeInterval:1388000 sinceDate:[NSDate dateWithTimeIntervalSince1970:[created_at doubleValue]]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if ([createDate isThisYear]) { // 今年
        if ([calendar isDateInToday:createDate]) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:createDate];
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                _created_at = [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                _created_at = [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                _created_at = @"刚刚";
            }
        }else if ([calendar isDateInYesterday:createDate]){ // 昨天
            fmt.dateFormat = @"昨天: HH:mm:ss";
            _created_at = [fmt stringFromDate:createDate];
        }else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            _created_at = [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        _created_at = created_at;
    }
}
@end
