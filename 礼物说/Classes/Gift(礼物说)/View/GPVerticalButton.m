//
//  TPCVerticalButton.m
//  百思不得姐
//
//  Created by tripleCC on 15/1/26.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPVerticalButton.h"

@implementation GPVerticalButton

- (void)awakeFromNib
{
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    self.adjustsImageWhenHighlighted = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.gp_width = self.gp_width * 0.5;
    self.imageView.gp_height = self.gp_width * 0.5;
    self.imageView.gp_centerX = self.gp_width * 0.5;
    self.imageView.y = self.gp_height * 0.1;
    
    self.titleLabel.gp_height = self.gp_height - self.imageView.gp_height - self.titleEdgeInsets.top;
    self.titleLabel.gp_width = self.gp_width;
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.gp_height + self.titleEdgeInsets.top;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}



@end
