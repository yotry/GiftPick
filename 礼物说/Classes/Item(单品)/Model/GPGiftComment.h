//
//  GPGiftComment.h
//  礼物说
//
//  Created by heew on 15/1/19.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPGiftComment : NSObject
@property (nonatomic, copy) NSString *content; /**你上次买的不是更便宜。。  */
@property (nonatomic, copy) NSString *created_at; /**创建时间  */
@property (nonatomic, copy) NSString *avatar_url; /**用户头像  */
@property (nonatomic, copy) NSString *nickname; /**用户昵称  */
@end
