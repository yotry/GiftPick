//
//  GPSearchGift.h
//  礼物说
//
//  Created by heew on 15/1/16.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSearchGift : NSObject
@property (nonatomic, copy) NSString *ID; /**图片 */
@property (nonatomic, copy) NSString *cover_image_url; /**图片 */
@property (nonatomic, copy) NSString *created_at; /**创建时间 */
@property (nonatomic, copy) NSString *giftDescription; /**礼物描述 */
@property (nonatomic, assign) BOOL is_favorite; /**是否喜欢 */
@property (nonatomic, copy) NSString *name; /**礼物名称 */
@property (nonatomic, copy) NSString *price; /**价格 */
@property (nonatomic, copy) NSString *purchase_id; /**购买id */
@property (nonatomic, assign) BOOL purchase_status; /**购买状态 */
@property (nonatomic, copy) NSString *purchase_url; /**购买地址 */
@property (nonatomic, copy) NSString *subcategory_id; /**子类id */
@property (nonatomic, copy) NSString *updated_at; /**更新时间 */
@property (nonatomic, strong) NSString *favorites_count; /**喜欢数 */
@property (nonatomic, strong) NSArray *image_urls; /**礼物详情页顶部图片数组 */
@property (nonatomic, copy) NSString *detail_html; /**图片详情  */
@property (nonatomic, assign) NSInteger comments_count; /**评论总个数 */
@property (nonatomic, copy) NSString *url; /**分享地址  */

//===================辅助模型======================//
@property (nonatomic, assign) CGFloat detailHeaderHeight; /**单品头部高度 */

@end
