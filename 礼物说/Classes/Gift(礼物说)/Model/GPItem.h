//
//  TPCItems.h
//  礼物说
//
//  Created by tripleCC on 15/1/13.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPItem : NSObject
@property (copy, nonatomic) NSString *content_url;
@property (copy, nonatomic) NSString *cover_image_url;
@property (copy, nonatomic) NSString *created_at;
@property (assign, nonatomic) NSUInteger ID;
@property (strong, nonatomic) NSArray *labels;
@property (assign, nonatomic) BOOL liked;
@property (assign, nonatomic) NSUInteger likes_count;
@property (assign, nonatomic) NSUInteger published_at;
@property (copy, nonatomic) NSString *share_msg;
@property (copy, nonatomic) NSString *short_title;
@property (assign, nonatomic) NSUInteger status;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *type;
@property (assign, nonatomic) NSUInteger updated_at;
@property (copy, nonatomic) NSString *url;
@end
