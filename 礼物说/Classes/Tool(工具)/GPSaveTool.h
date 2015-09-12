//
//  TPCSaveTool.h
//  礼物说
//
//  Created by tripleCC on 15/1/8.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <Foundation/Foundation.h>

#define GPSaveKeySearchHistory @"GPSearchHistory"

@interface GPSaveTool : NSObject
+ (void)setObject:(id)obj forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;
@end
