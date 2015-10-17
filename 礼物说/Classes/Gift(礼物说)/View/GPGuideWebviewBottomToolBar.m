//
//  GPGuideWebviewBottomToolBar.m
//  礼物说
//
//  Created by tripleCC on 15/1/20.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPGuideWebviewBottomToolBar.h"

@interface GPGuideWebviewBottomToolBar()

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@end

@implementation GPGuideWebviewBottomToolBar
+ (instancetype)guideWebviewBottomToolBar
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
- (void)addLikeButtonTarget:(id)target action:(SEL)action {
    [self.likeButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addShareButtonTarget:(id)target action:(SEL)action {
    [self.shareButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addCommentButtonTarget:(id)target action:(SEL)action {
    [self.commentButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
