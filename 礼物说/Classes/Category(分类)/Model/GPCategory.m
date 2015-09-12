//
//  GPCategories.m
//  礼物说
//
//  Created by heew on 15/1/22.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPCategory.h"

@implementation GPCategory
+ (NSDictionary *)objectClassInArray {
   return @{@"subcategories" : @"GPSubCategory"};
}
@end
