//
//  TPCLikeCountButton.m
//  礼物说
//
//  Created by tripleCC on 15/1/15.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPLikeCountButton.h"

@implementation GPLikeCountButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.cornerBoarderColor = [UIColor lightGrayColor];
    self.cornerBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.cornerBoarderRadius = self.gp_height * 0.5;
}

@end
