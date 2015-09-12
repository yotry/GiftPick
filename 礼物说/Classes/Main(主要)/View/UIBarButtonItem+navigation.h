//
//  UIBarButtonItem+navigation.h
//
//  Created by heew on 15/6/11.
//  Copyright (c) 2014年 adhx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (navigation)
+ (instancetype)itemWithbg:(NSString *)bgimage bgHighlighted:(NSString *)bgimageHighlighted target:(id)obj action:(SEL)action;
@end
