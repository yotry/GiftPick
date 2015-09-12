//
//  GPSubCategoryCell.h
//  礼物说
//
//  Created by heew on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPSubCategory;
static NSString * const subCategoryIdentifier = @"subCategory";
@interface GPSubCategoryCell : UICollectionViewCell
@property (nonatomic, strong) GPSubCategory *subCategory; /**子分类模型 */

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@end
