//
//  GPSearchGiftHeader.h
//  礼物说
//
//  Created by heew on 15/1/16.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "MJRefreshGifHeader.h"

@interface GPSearchGiftHeader : MJRefreshGifHeader
@end


@interface UIImage (Size) // 把图片缩放为制定大小的图片
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
@end