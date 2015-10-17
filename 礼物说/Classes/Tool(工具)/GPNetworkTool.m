//
//  GPNetworkTool.m
//  礼物说
//
//  Created by tripleCC on 15/10/17.
//  Copyright © 2015年 tripleCC. All rights reserved.
//

#import "GPNetworkTool.h"

@implementation GPNetworkTool

static GPNetworkTool *_instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

+ (instancetype)sharedNetworkTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    return [super initWithBaseURL:[NSURL URLWithString:@"http://api.liwushuo.com/"]];
}
@end
