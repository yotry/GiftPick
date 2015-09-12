//
//  GPBrandDetailSegment.m
//  礼物说
//
//  Created by tripleCC on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPBrandDetailSegment.h"

@interface GPBrandDetailSegment()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorViewToAllGiftButtonLeading;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *seperatorLines;
@end

@implementation GPBrandDetailSegment

+ (instancetype)segment
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [self.seperatorLines makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
}

- (IBAction)leftButtonOnClick:(UIButton *)sender {
    self.indicatorViewToAllGiftButtonLeading.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}
- (IBAction)rightButtonOnClick:(UIButton *)sender {
    self.indicatorViewToAllGiftButtonLeading.constant = sender.gp_width;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)leftButtonAddTarget:(id) target selector:(SEL)action forContrlEvents:(UIControlEvents)controlEvents {
    [self.leftButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)rightButtonAddTarget:(id) target selector:(SEL)action forContrlEvents:(UIControlEvents)controlEvents {
    [self.rightButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle = [leftTitle copy];
    
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
}

- (void)setRightTitle:(NSString *)rightTitle
{
    _rightTitle = [rightTitle copy];
    
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
}

- (void)setShowSeperatorLines:(BOOL)showSeperatorLines
{
    _showSeperatorLines = showSeperatorLines;

    // 不知道这样为什么不行，还是会隐藏
//    [self.seperatorLines makeObjectsPerformSelector:@selector(setHidden:) withObject:@(NO)];

    for (UIView *view in self.seperatorLines) {
        view.hidden = NO;
    }
}

@end
