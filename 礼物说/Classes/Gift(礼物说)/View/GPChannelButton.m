//
//  TPCChannelButton.m
//  礼物说
//
//  Created by tripleCC on 15/1/11.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPChannelButton.h"

@interface GPChannelButton()
@property (weak, nonatomic) UIButton *deleteButton;
@end

@implementation GPChannelButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.adjustsImageWhenHighlighted = NO;
    [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    self.deleteButton = deleteButton;
    self.cornerBoarderRadius = 1;
    self.cornerBoarderColor = TPCRGBColor(230, 230, 230);
}

- (void)deleteButtonOnClick:(UIButton *)btn
{
    !self.deleteOperate ? : self.deleteOperate(self);
}

// 使删除按钮点击范围恢复正常
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 这里注意一定要判断好了！否则即使父控件隐藏，还是会触发deleteButton的动作
    if (!self.isHidden && self.alpha > 0.01 && self.userInteractionEnabled == YES) {
        CGPoint deletePoint = [self convertPoint:point toView:self.deleteButton];
        if ([self.deleteButton pointInside:deletePoint withEvent:event]) {
            return self.deleteButton;
        } 
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat centerOffset = 2;
    
    // 右上角
    self.deleteButton.gp_width = self.gp_width * 0.25;
    self.deleteButton.gp_height = self.deleteButton.gp_width;
    
    self.deleteButton.gp_centerX = self.gp_width - centerOffset;
    self.deleteButton.gp_centerY = centerOffset;
}

- (void)setHideDeleteButton:(BOOL)hideDeleteButton
{
    _hideDeleteButton = hideDeleteButton;
    self.deleteButton.hidden = hideDeleteButton;
}

- (void)replaceActionFromAction:(SEL)from toAction:(SEL)to forControlEvents:(UIControlEvents)controlEvents
{
    // 这里要注意先缓存，否则当target没有动作时，它会被移除
    id target =[self.allTargets anyObject];
    
    [self removeTarget:target action:from forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:target action:to forControlEvents:UIControlEventTouchUpInside];
}
@end
