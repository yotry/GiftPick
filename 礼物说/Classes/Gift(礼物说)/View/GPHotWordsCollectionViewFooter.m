//
//  hotWordsCollectionViewFooter.m
//  礼物说
//
//  Created by tripleCC on 15/8/27.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "GPHotWordsCollectionViewFooter.h"

@interface GPHotWordsCollectionViewFooter()
@property (weak, nonatomic) IBOutlet UIButton *clearSearchButton;

@end

@implementation GPHotWordsCollectionViewFooter
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.clearSearchButton addTarget:target action:action forControlEvents:controlEvents];
}
@end
