//
//  GPHotWordsCollectionViewHeaderw.m
//  礼物说
//
//  Created by tripleCC on 15/8/27.
//  Copyright (c) 2015年 tripleCC. All rights reserved.
//

#import "GPHotWordsCollectionViewHeader.h"

@interface GPHotWordsCollectionViewHeader()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation GPHotWordsCollectionViewHeader

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    self.nameLabel.text = title;
}

@end
