//
//  TPCEditChannelView.m
//  礼物说
//
//  Created by tripleCC on 15/1/10.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPEditChannelView.h"
#import "GPChannelButton.h"

static const CGFloat TPCEditChannelHorizontalMargin = 15;
static const CGFloat TPCEditChannelVerticalMargin = 20;
static const CGFloat TPCEditChannelMarginX = 10;
static const CGFloat TPCEditChannelMarginY = 15;
static const CGFloat TPCEditChannelExtraWidth = 35;
static const CGFloat TPCEditChannelHeight = 30;
static const CGFloat TPCEditChannelAddMoreChannelLabelH = 50;
static const NSTimeInterval TPCEditChannelAnimationDuration = 0.25;
static NSString * const TPCEditChannelShakeAnimationKey = @"TPCEditChannelShakeAnimationKey";
static NSString * const TPCEditChannelMagnifyAnimationKey = @"TPCEditChannelMagnifyAnimationKey";

@interface GPEditChannelView() <UIGestureRecognizerDelegate>
/** 需要的标签 */
@property (strong, nonatomic) NSMutableArray *neededChannelTitles;
@property (strong, nonatomic) NSMutableArray *neededChannelButtons;

/** 移除的标签 */
@property (strong, nonatomic) NSMutableArray *removedChannelTitles;
@property (strong, nonatomic) NSMutableArray *removedChannelButtons;

/** 点击添加更多频道Label */
@property (weak, nonatomic) UIButton *addMoreChannelButton;

/** 选择要排序的按钮 */
@property (weak, nonatomic) GPChannelButton *selectedButton;

/** 占位按钮 */
@property (weak, nonatomic) GPChannelButton *placeholderButton;

/** 是否为正常状态 */
@property (assign, nonatomic, getter=isInNormalMode) BOOL inNormalMode;

/** 是否为排序状态 */
@property (assign, nonatomic, getter=isInSortMode) BOOL inSortMode;
@end

@implementation GPEditChannelView
#pragma mark 懒加载

- (GPChannelButton *)placeholderButton
{
    if (_placeholderButton == nil) {
        GPChannelButton *placeholderButton = [GPChannelButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:placeholderButton];
        _placeholderButton = placeholderButton;
    }
    
    return _placeholderButton;
}

- (UIButton *)addMoreChannelButton
{
    if (_addMoreChannelButton == nil) {
        UIButton *Channel = [[UIButton alloc] init];
        Channel.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [Channel setTitle:@"点击添加更多频道" forState:UIControlStateNormal];
        Channel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        Channel.titleEdgeInsets = UIEdgeInsetsMake(0, TPCEditChannelHorizontalMargin, 0, TPCEditChannelHorizontalMargin);
        Channel.userInteractionEnabled = NO;
        Channel.backgroundColor = TPCRGBColor(230, 230, 230);
        [Channel setTitleColor:TPCRGBColor(137, 137, 141) forState:UIControlStateNormal];
        Channel.gp_height = TPCEditChannelAddMoreChannelLabelH;
        Channel.x = 0;
        [self addSubview:Channel];
        _addMoreChannelButton = Channel;
    }
    
    return _addMoreChannelButton;
}

- (NSMutableArray *)neededChannelTitles
{
    if (_neededChannelTitles == nil) {
        _neededChannelTitles = @[].mutableCopy;
    }
    
    return _neededChannelTitles;
}

- (NSMutableArray *)neededChannelButtons
{
    if (_neededChannelButtons == nil) {
        _neededChannelButtons = @[].mutableCopy;
    }
    
    return _neededChannelButtons;
}

- (NSMutableArray *)removedChannelTitles
{
    if (_removedChannelTitles == nil) {
        _removedChannelTitles = @[].mutableCopy;
    }
    
    return _removedChannelTitles;
}

- (NSMutableArray *)removedChannelButtons
{
    if (_removedChannelButtons == nil) {
        _removedChannelButtons = @[].mutableCopy;
    }
    
    return _removedChannelButtons;
}

#pragma mark 初始化控件、子控件
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.neededChannelTitles addObjectsFromArray:@[@"精选", @"运动", @"礼物", @"美食", @"数码", @"娱乐"]];
        [self setupNeededChannelButtons];
        [self setupRemovedChannelButtons];
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self switchToNormalMode];
}

/**
 *  设置需要的频道
 */
- (void)setupNeededChannelButtons
{
    for (NSInteger i = 0; i < self.neededChannelTitles.count; i++) {
        GPChannelButton *btn = [GPChannelButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn setTitleColor:TPCTitleGrayColor forState:UIControlStateNormal];
        [btn setTitle:self.neededChannelTitles[i] forState:UIControlStateNormal];
/*** Bugfix：这里使用图层会使按钮的删除图片受到影响 ***/
//        btn.layer.borderWidth = 1.0;
        [btn addTarget:self action:@selector(neededChannelButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) weakSelf = self;
        [btn setDeleteOperate:^(GPChannelButton *btn){
            // 先隐藏按钮
            btn.hidden = YES;
            [weakSelf moveChannel:btn From:self.neededChannelButtons to:self.removedChannelButtons];
            // 替换原来的动作
            [btn replaceActionFromAction:@selector(neededChannelButtonOnClick:)
                                toAction:@selector(removedChannelButtonOnClick:)
                        forControlEvents:UIControlEventTouchUpInside];
        }];
        [self addSubview:btn];
        [self.neededChannelButtons addObject:btn];
    }
}

/**
 *  设置精选按钮
 */
- (void)updateChoicenessChannelButton
{
    GPChannelButton *btn = [self.neededChannelButtons firstObject];
    if (self.isInNormalMode) {
        btn.backgroundColor = [UIColor whiteColor];
        btn.cornerBoarderRadius = 1;
    } else {
        btn.backgroundColor = [UIColor clearColor];
        btn.cornerBoarderRadius = 0;
    }
}

/**
 *  设置移除的频道
 */
- (void)setupRemovedChannelButtons
{
    for (NSInteger i = 0; i < self.removedChannelTitles.count; i++) {
        GPChannelButton *btn = [GPChannelButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn setTitleColor:TPCTitleGrayColor forState:UIControlStateNormal];
        [btn setTitle:self.removedChannelTitles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(removedChannelButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btn];
        [self.removedChannelButtons addObject:btn];
    }
}

- (void)neededChannelButtonOnClick:(GPChannelButton *)btn
{
    NSLog(@"%s--%@", __func__, btn.currentTitle);
//#warning 传出选中的按钮文字，然后在主界面显示对应的频道
}

- (void)removedChannelButtonOnClick:(GPChannelButton *)btn
{
    [self moveChannel:btn From:self.removedChannelButtons to:self.neededChannelButtons];

    // 替换原来的动作
    [btn replaceActionFromAction:@selector(removedChannelButtonOnClick:)
                        toAction:@selector(neededChannelButtonOnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"%s", __func__);
}

/**
 *  移动频道至对应的组别
 *
 *  @param btn  频道对应的按钮
 *  @param from 频道源组别
 *  @param to   频道目标组别
 */
- (void)moveChannel:(GPChannelButton *)btn From:(NSMutableArray *)from to:(NSMutableArray *)to
{
    [to addObject:btn];
    [from removeObject:btn];
    [self updateChannelsWithAnimationDuration:TPCEditChannelAnimationDuration];
}

/**
 *  动态更新频道的尺寸
 *
 *  @param duration 动画时间
 */
- (void)updateChannelsWithAnimationDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        [self updateChannelButtonsFrame:self.neededChannelButtons originY:TPCEditChannelVerticalMargin];
        [self setupAddMoreChannelLabelFrame];
    }];
}

#pragma mark 模式切换
/**
 *  切换到正常模式
 */
- (void)switchToNormalMode
{
    self.inNormalMode = YES;
    
    [self updateChoicenessChannelButton];
    
    // 隐藏按钮删除图标
    for (GPChannelButton *btn in self.neededChannelButtons) {
        btn.hideDeleteButton = YES;
    }
    for (GPChannelButton *btn in self.removedChannelButtons) {
        btn.hideDeleteButton = YES;
    }
    
    // 正常模式显示删除的模式
    [self.removedChannelButtons makeObjectsPerformSelector:@selector(setHidden:) withObject:@(NO)];
    
    // 更新删除频道按钮的坐标
    [self updateChannelButtonsFrame:self.removedChannelButtons
                            originY:CGRectGetMaxY(self.addMoreChannelButton.frame) + TPCEditChannelVerticalMargin];
    // 更新需要的状态
    [self updateChannelButtonsFrame:self.neededChannelButtons originY:TPCEditChannelVerticalMargin];
    
    // 移除所有频道按钮的动画
    [self removeShakeAnimationOfAllChannelButtons];
}

/**
 *  切换到删除排序模式
 */
- (void)switchToDeleteMode
{
    self.inNormalMode = NO;
    
    [self updateChoicenessChannelButton];
    
    // 显示按钮删除图标
    for (GPChannelButton *btn in self.neededChannelButtons) {
        btn.hideDeleteButton = !btn.cornerBoarderRadius;
    }
    
    // 编辑模式隐藏删除的模式
    [self.removedChannelButtons makeObjectsPerformSelector:@selector(setHidden:) withObject:@(YES)];
    
    // 进入删除排序模式需要隐藏提示按钮
    self.addMoreChannelButton.hidden = YES;
    
    // 给需要的频道按钮添加核心动画
    [self addShakeAnimationToNeededChannelButtons];
    
    // 给按钮添加手势
    [self addGestureToNeededChannelButtons];
}

/**
 *  添加手势
 */
- (void)addGestureToNeededChannelButtons
{
    for (GPChannelButton *btn in self.neededChannelButtons) {
        // 非精选
        if (btn.cornerBoarderRadius) {
            // 非重复添加手势
            if (!btn.gestureRecognizers.count) {
                // 添加长按手势
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
                longPress.delegate = self;
                longPress.minimumPressDuration = 0.4;
                [btn addGestureRecognizer:longPress];
                
                // 添加拖拽手势
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
                [btn addGestureRecognizer:pan];
            }
        }
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 获取手势对应的按钮
    GPChannelButton *panBtn = (GPChannelButton *)pan.view;
    
    CGPoint translationP = [pan translationInView:self];
    // 放大时才可以拖拽
//    if ([panBtn.layer animationForKey:TPCEditChannelMagnifyAnimationKey]) {
//        if (pan.state == UIGestureRecognizerStateBegan) {
//            // 纪录拖拽的按钮
//            self.selectedButton = panBtn;
//            NSUInteger index = [self.neededChannelButtons indexOfObject:panBtn];
//            
//            // 将拖拽的按钮从需要频道按钮数组中删除
//            [self.neededChannelButtons removeObject:panBtn];
//            
//            // 拖拽的按钮位置用占位按钮顶替
//            self.placeholderButton.frame = panBtn.frame;
//            [self.neededChannelButtons replaceObjectAtIndex:index withObject:self.placeholderButton];
//            
//        } else if (pan.state == UIGestureRecognizerStateChanged) {
//            panBtn.transform = CGAffineTransformTranslate(panBtn.transform, translationP.x, translationP.y);
//            
//            for (TPCChannelButton *btn in self.neededChannelButtons) {
//                if (CGRectIntersectsRect(btn.frame, panBtn.frame)) {
//                    if (panBtn.centerX > btn.centerX) {
//                        // btn左移
//                    } else {
//                        // btn右移
//                    }
//                }
//            }
//        } else if (pan.state == UIGestureRecognizerStateEnded) {
//            
//        }
//    }
    [pan setTranslation:CGPointZero inView:self];
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    // 获取手势对应的按钮
    GPChannelButton *btn = (GPChannelButton *)gesture.view;
    
    // 右上角删除按钮出现时，才允许放大
    if (!btn.isHideDeleteButton) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            // 放大时设置为排序模式
            self.inSortMode = YES;
            [self removeShakeAnimationOfAllChannelButtons];
            // 添加放大动画
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            anim.toValue = @(1.1);
            anim.duration = 0.2;
            anim.removedOnCompletion = NO;
            anim.fillMode = kCAFillModeForwards;
            [btn.layer addAnimation:anim forKey:TPCEditChannelMagnifyAnimationKey];
            
            // 将按钮移动到最前面
            [self insertSubview:btn atIndex:self.subviews.count - 1];
        } else if (gesture.state == UIGestureRecognizerStateEnded) {
            // 方法结束，设置为非排序模式
            self.inSortMode = NO;
            [self addShakeAnimationToNeededChannelButtons];
            // 移除放大动画
            [btn.layer removeAnimationForKey:TPCEditChannelMagnifyAnimationKey];
        }
    }
}

/**
 *   给需要的频道按钮添加核心动画
 */
- (void)addShakeAnimationToNeededChannelButtons
{
    for (GPChannelButton *btn in self.neededChannelButtons) {
        // 非精选
        if (btn.cornerBoarderRadius) {
            // 非叠加动画
            if (![btn.layer animationForKey:TPCEditChannelShakeAnimationKey]) {
                CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
                anim.values = @[@(-M_PI_4 * 0.02), @(M_PI_4 * 0.02), @(-M_PI_4 * 0.02)];
                anim.removedOnCompletion = NO;
                anim.fillMode = kCAFillModeForwards;
                anim.duration = 0.2;
                anim.repeatCount = MAXFLOAT;
                [btn.layer addAnimation:anim forKey:TPCEditChannelShakeAnimationKey];
            }
        }
    }
}

/**
 *  移除所有频道按钮的动画
 */
- (void)removeShakeAnimationOfAllChannelButtons
{
    for (GPChannelButton *btn in self.neededChannelButtons) {
        [btn.layer removeAnimationForKey:TPCEditChannelShakeAnimationKey];
    }
    
    for (GPChannelButton *btn in self.removedChannelButtons) {
        [btn.layer removeAnimationForKey:TPCEditChannelShakeAnimationKey];
    }
}

#pragma mark UIGestureRecognizerDelegate
// 允许多手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark 更新频道尺寸
/**
 *  更新频道尺寸
 *
 *  @param channels 需要更新尺寸的频道组别
 *  @param originY  原始Y坐标
 */
- (void)updateChannelButtonsFrame:(NSArray *)channels originY:(CGFloat)originY
{
    for (NSInteger i = 0; i < channels.count; i++) {
        UIButton *btn = channels[i];
        [btn sizeToFit];
        btn.gp_width += TPCEditChannelExtraWidth;
        btn.gp_height = TPCEditChannelHeight;
        if (i == 0) {
            btn.y = originY;
            btn.x = TPCEditChannelHorizontalMargin;
        } else {
            UIButton *previousBtn = channels[i - 1];
            if (CGRectGetMaxX(previousBtn.frame) + TPCEditChannelHorizontalMargin + btn.gp_width + TPCEditChannelMarginX > TPCScreenW) {
                btn.y = CGRectGetMaxY(previousBtn.frame) + TPCEditChannelMarginY;
                btn.x = TPCEditChannelHorizontalMargin;
            } else {
                btn.y = previousBtn.y;
                btn.x = CGRectGetMaxX(previousBtn.frame) + TPCEditChannelMarginX;
            }
        }
    }
}

/**
 *  设置添加更多频道提示Label
 */
- (void)setupAddMoreChannelLabelFrame
{
    self.addMoreChannelButton.gp_width = self.gp_width;
    self.addMoreChannelButton.y = CGRectGetMaxY([[self.neededChannelButtons lastObject] frame]) + TPCEditChannelMarginY;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 正常状态下才更新
    if (self.isInNormalMode) {
        // 根据移除频道的数量，决定添加更多频道按钮是否显示
        self.addMoreChannelButton.hidden = !self.removedChannelButtons.count;
        
        // 隐藏了说明没有删除的频道，所以也不用更新删除的频道
        if (!self.addMoreChannelButton.isHidden) {
            // 更新提示Label
            [self setupAddMoreChannelLabelFrame];

            // 更新移除的频道
            [self updateChannelButtonsFrame:self.removedChannelButtons originY:CGRectGetMaxY(self.addMoreChannelButton.frame) + TPCEditChannelVerticalMargin];
        }
    } else {
        if (!self.isInSortMode) {
            // 更新需要的频道
            [self updateChannelButtonsFrame:self.neededChannelButtons originY:TPCEditChannelVerticalMargin];
        } else {
            
        }
    }
}


@end
