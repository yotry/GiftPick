//
//  GPBrandDetailHeadImageView.h
//  礼物说
//
//  Created by tripleCC on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPBrandDetail;
@interface GPBrandDetailHeadImageView : UIView
@property (strong, nonatomic) GPBrandDetail *brandDetail;

+ (instancetype)headImageView;
@end
