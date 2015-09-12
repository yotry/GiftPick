//
//  GPBrandDetail.h
//  礼物说
//
//  Created by tripleCC on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPBrandDetail : NSObject
@property (copy, nonatomic) NSString *cover_image_url;
@property (copy, nonatomic) NSString *created_at;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *icon_url;
@property (assign, nonatomic) NSInteger ID;
@property (strong, nonatomic) NSArray *image_urls;
@property (assign, nonatomic) NSInteger items_count;
@property (copy, nonatomic) NSString *intro_html;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger status;
@property (copy, nonatomic) NSString *updated_at;
@end
