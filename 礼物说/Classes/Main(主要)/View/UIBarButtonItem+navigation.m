//
//  UIBarButtonItem+navigation.m
//
//
//  Created by heew on 15/6/11.
//  Copyright (c) 2014年 adhx. All rights reserved.
//

#import "UIBarButtonItem+navigation.h"

@implementation UIBarButtonItem (navigation)
+ (instancetype)itemWithbg:(NSString *)bgimage bgHighlighted:(NSString *)bgimageHighlighted target:(id)obj action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    
    [button setBackgroundImage:[[UIImage imageNamed:bgimage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    if (bgimageHighlighted) {
        [button setBackgroundImage:[[UIImage imageNamed:bgimageHighlighted] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    }
    button.frame = CGRectMake(0, 0, button.currentBackgroundImage.size.width, button.currentBackgroundImage.size.height);
    [button addTarget:obj action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}
@end
