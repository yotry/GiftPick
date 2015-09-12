//
//  GPHotWordsCell.m
//  礼物说
//
//  Created by tripleCC on 15/1/25.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPHotWordsCell.h"
#import "TPCButton.h"

@interface GPHotWordsCell()

@property (weak, nonatomic) TPCButton *titleButton;
@end

@implementation GPHotWordsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        TPCButton *button = [TPCButton buttonWithType:UIButtonTypeCustom];
        button.cornerBoarderRadius = 4;
        button.cornerBoarderColor = TPCRGBColor(230, 230, 230);
        [button setTitleColor:TPCTitleGrayColor forState:UIControlStateNormal];
        button.titleLabel.font = GPHotWordsFont;
        // 这里注意要不使能用户交互，不然会拦截cell的点击
        button.userInteractionEnabled = NO;
        [self addSubview:button];
        self.titleButton = button;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleButton.frame = self.bounds;
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    [self.titleButton setTitle:title forState:UIControlStateNormal];
}
@end
