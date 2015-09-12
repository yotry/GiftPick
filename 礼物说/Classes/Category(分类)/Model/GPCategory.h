//
//  GPCategories.h
//  礼物说
//
//  Created by heew on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPCategory : NSObject
@property (nonatomic, copy) NSString *icon_url; /**图标地址  */
@property (nonatomic, copy) NSString *ID; /**编号  */
@property (nonatomic, copy) NSString *name; /**分类标题  */
@property (nonatomic, strong) NSArray *subcategories; /**子分类模型 */
@end
