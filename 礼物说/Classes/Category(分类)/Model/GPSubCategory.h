//
//  GPSubCategory.h
//  礼物说
//
//  Created by heew on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSubCategory : NSObject
@property (nonatomic, copy) NSString *name; /**子分类名称  */
@property (nonatomic, copy) NSString *icon_url; /**图标地址  */
@property (nonatomic, assign) NSInteger ID; /**编号  */
@end
