//
//  GPRaiderCollection.h
//  礼物说
//
//  Created by heew on 15/1/23.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPRaiderCollection : NSObject
@property (nonatomic, copy) NSString *banner_image_url; /**banner地址  */
@property (nonatomic, assign) NSInteger ID; /**ID  */
@property (nonatomic, copy) NSString *subtitle; /**子标题  */
@property (nonatomic, copy) NSString *title; /**标题  */
@property (nonatomic, copy) NSString *posts_count; /**发布数量  */
@end
