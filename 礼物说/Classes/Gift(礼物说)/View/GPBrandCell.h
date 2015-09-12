//
//  GPBrandCell.h
//  礼物说
//
//  Created by tripleCC on 15/1/16.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPBrand;
@interface GPBrandCell : UITableViewCell
@property (strong, nonatomic) GPBrand *brand;
/** 大图在左边 */
@property (assign, nonatomic, getter=isBigImageViewLeft) BOOL bigImageViewLeft;
@end
