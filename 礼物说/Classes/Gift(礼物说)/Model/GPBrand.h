//
//  GPBrand.h
//  礼物说
//
//  Created by tripleCC on 15/1/16.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPBrand : NSObject
@property (copy, nonatomic) NSString *cover_image_url;
@property (copy, nonatomic) NSString *created_at;
@property (copy, nonatomic) NSString *desc;
@property (assign, nonatomic) NSInteger ID;
@property (strong, nonatomic) NSArray *image_urls;
@property (assign, nonatomic) NSInteger items_count;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger updated_at;
@end