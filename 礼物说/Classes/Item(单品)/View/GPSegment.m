//
//  GPSegment.m
//  礼物说
//
//  Created by heew on 15/1/18.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPSegment.h"
#import "GPSearchGift.h"

@interface GPSegment ()
@property (weak, nonatomic) IBOutlet UIButton *desc;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redViewLeftConstraint;
- (IBAction)descClick:(UIButton *)sender;
- (IBAction)commentClick:(UIButton *)sender;

@end

@implementation GPSegment

+ (instancetype)segment {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
- (void)awakeFromNib {
    self.desc.layer.borderColor = TPCRGBColor(220, 220, 220).CGColor;
    self.comment.layer.borderColor = TPCRGBColor(220, 220, 220).CGColor;
    self.desc.layer.borderWidth = 0.5;
    self.comment.layer.borderWidth = 0.5;
    self.autoresizingMask = UIViewAutoresizingNone;
}


- (void)descButtonAddTarget:(id) target selector:(SEL)action forContrlEvents:(UIControlEvents)controlEvents {
    [self.desc addTarget:target action:action forControlEvents:controlEvents];
}

- (void)commentButtonAddTarget:(id) target selector:(SEL)action forContrlEvents:(UIControlEvents)controlEvents {
    [self.comment addTarget:target action:action forControlEvents:controlEvents];
}

- (IBAction)descClick:(UIButton *)sender {
    self.redViewLeftConstraint.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.redView layoutIfNeeded];
    }];
}

- (IBAction)commentClick:(UIButton *)sender {
    self.redViewLeftConstraint.constant = sender.gp_width;
    [UIView animateWithDuration:0.5 animations:^{
        [self.redView layoutIfNeeded];
    }];
}

- (void)setGift:(GPSearchGift *)gift {
    _gift = gift;
    [self.comment setTitle:[NSString stringWithFormat:@"评论(%zd)",gift.comments_count] forState:UIControlStateNormal];
}

@end
