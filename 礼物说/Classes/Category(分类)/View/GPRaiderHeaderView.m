//
//  GPRaiderHeaderView.m
//  礼物说
//
//  Created by heew on 15/1/23.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPRaiderHeaderView.h"
#import "GPRaiderCollection.h"

@interface GPRaiderHeaderView ()
@property (nonatomic, weak) UIButton *checkAllButton; /**查看全部按钮 */
@property (nonatomic, weak) UIScrollView *scrollView; /**滚动条 */
@property (nonatomic, weak) UIImageView *lastImageView; /**记录上一个图片 */
@end

@implementation GPRaiderHeaderView


+ (instancetype)raiderHeaderView {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [self addSubview:titleLabel];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(10);
            make.height.equalTo(20);
        }];
        titleLabel.text = @"专题";
        [titleLabel setTintColor:[UIColor blackColor]];
        titleLabel.font = [UIFont systemFontOfSize:14];
//        [titleLabel layoutIfNeeded];
        
        UIButton *checkAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkAllButton setTitle:@"查看全部>" forState:UIControlStateNormal];
        [checkAllButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [checkAllButton addTarget:self action:@selector(checkAllButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        checkAllButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:checkAllButton];
        [checkAllButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.right.equalTo(self.right).offset(-10);
        }];
        self.checkAllButton = checkAllButton;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        [scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(checkAllButton.bottom).offset(10);
            make.left.right.bottom.equalTo(self);
        }];
        self.scrollView = scrollView;
    }
    return self;
}

- (void)checkAllButtonClicked {
    NSLog(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(raiderHeaderViewDidClickCheckAllButton:)]) {
        [self.delegate raiderHeaderViewDidClickCheckAllButton:self];
    }
}

- (void)setCollections:(NSArray *)collections {
    _collections  = collections;
    for (int i = 0; i < collections.count; i++) {
        // 添加子控件
        GPRaiderCollection *collection = collections[i];
        RaiderHeaderImageView *imageView = [[RaiderHeaderImageView alloc] init];
        imageView.collection = collection;
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:collection.banner_image_url] placeholderImage:[UIImage imageNamed:@"searchGift_placeHolder"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)];
        [imageView addGestureRecognizer:tap];
        
        // 布局子控件
        if (i == 0) {
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.scrollView).offset(10);
                make.bottom.equalTo(self.scrollView).offset(-10);
                make.width.equalTo(imageView.height).multipliedBy(2);
                make.height.equalTo(self.scrollView.height).offset(-20);
            }];
            self.lastImageView = imageView;
        }else if (i > 0 && i < collections.count - 1) {
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lastImageView.right).offset(10);
                make.bottom.equalTo(self.scrollView).offset(-10);
                make.top.equalTo(self.scrollView).offset(10);
                make.width.equalTo(imageView.height).multipliedBy(2);
                make.height.equalTo(self.scrollView.height).offset(-20);
            }];
            self.lastImageView = imageView;
        } else {
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lastImageView.right).offset(10);
                make.bottom.equalTo(self.scrollView).offset(-10);
                make.top.equalTo(self.scrollView).offset(10);
                make.width.equalTo(imageView.height).multipliedBy(2);
                make.height.equalTo(self.scrollView.height).offset(-20);
                make.right.equalTo(self.scrollView).offset(-10);
            }];
        }
    }
}


- (void)imageViewDidClick:(UITapGestureRecognizer *)tap {
    RaiderHeaderImageView *imageView = (RaiderHeaderImageView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(raiderHeaderViewDidClickWithCollection:)]) {
        [self.delegate raiderHeaderViewDidClickWithCollection:imageView.collection];
    }
}

@end

@implementation RaiderHeaderImageView : UIImageView
@end
