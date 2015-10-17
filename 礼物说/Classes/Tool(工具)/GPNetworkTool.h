//
//  GPNetworkTool.h
//  礼物说
//
//  Created by tripleCC on 15/10/17.
//  Copyright © 2015年 tripleCC. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface GPNetworkTool : AFHTTPSessionManager
+ (instancetype)sharedNetworkTool;
@end
