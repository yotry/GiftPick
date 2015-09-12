//
//  HYWRecommentCategeryCell.h
//  百思不得姐
//
//  Created by heew on 15/1/22.
//  Copyright (c) 2014年 adhx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPCategory;
@interface GPCategoryCell : UITableViewCell
/**模型 */
@property (nonatomic, strong) GPCategory *category;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
