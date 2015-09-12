//
//  GPChannel.h
//  礼物说
//
//  Created by heew on 15/1/20.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPChannel : NSObject
@property (nonatomic, copy) NSString *icon_url; /**channel图标  */
@property (nonatomic, copy) NSString *name; /**"礼物"  */
@property (nonatomic, assign) NSInteger items_count; /**853 */
@property (nonatomic, assign) NSInteger ID; /**编号 */

@end
