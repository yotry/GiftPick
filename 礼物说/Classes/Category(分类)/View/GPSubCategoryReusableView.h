//
//  GPSubCategoryReusableView.h
//  礼物说
//
//  Created by heew on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPCategory;
static NSString * const reuseHeaderIdentifier = @"category";
@interface GPSubCategoryReusableView : UICollectionReusableView
@property (nonatomic, strong) GPCategory *catetory; /**分类模型 */
+ (instancetype)reuseViewWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@end
