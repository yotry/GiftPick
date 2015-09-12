//
//  HYWRecommentCategeryCell.m
//  百思不得姐
//
//  Created by heew on 15/1/22.
//  Copyright (c) 2014年 adhx. All rights reserved.
//

#import "GPCategoryCell.h"
#import "GPCategory.h"


@interface GPCategoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIView *redView;

@end
@implementation GPCategoryCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    GPCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"category"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)setCategory:(GPCategory *)category
{
    _category = category;
    self.categoryLabel.text = category.name;
}

- (void)awakeFromNib {
    self.backgroundColor = TPCRGBColor(244, 244, 244);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.redView.hidden = !selected;
    self.categoryLabel.textColor = selected ? TPCRGBColor(219, 21, 26) : TPCRGBColor(78, 78, 78);
}


@end
