//
//  TPCBanner.h
//  礼物说
//
//  Created by tripleCC on 15/1/8.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPBannerTarget;
@interface GPBanner : NSObject
@property (copy, nonatomic) NSString *image_url;
@property (copy, nonatomic) NSString *target_id;
@property (copy, nonatomic) NSString *target_url;
@property (copy, nonatomic) NSString *type;
@property (strong, nonatomic) GPBannerTarget *target;
@end
