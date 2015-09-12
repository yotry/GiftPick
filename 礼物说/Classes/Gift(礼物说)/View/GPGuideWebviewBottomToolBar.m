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
@end
