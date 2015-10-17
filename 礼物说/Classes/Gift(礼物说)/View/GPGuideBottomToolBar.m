//
//  GPGuideBottomTool.m
//  礼物说
//
//  Created by tripleCC on 15/1/20.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPGuideBottomToolBar.h"

@interface GPGuideBottomToolBar()
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@end

@implementation GPGuideBottomToolBar

+ (instancetype)guideBottomToolBar
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (IBAction)likeButtonOnClick:(id)sender {
    
    NSLog(@"%s", __func__);
}

- (IBAction)shareButtonOnClick:(id)sender {
    NSLog(@"%s", __func__);
}

- (IBAction)commentButtonOnClick:(id)sender {
    NSLog(@"%s", __func__);    
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
