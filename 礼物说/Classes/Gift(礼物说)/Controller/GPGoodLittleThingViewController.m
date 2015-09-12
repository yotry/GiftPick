//
//  GPGoodLittleThingViewController.m
//  礼物说
//
//  Created by tripleCC on 15/1/16.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPGoodLittleThingViewController.h"

@interface GPGoodLittleThingViewController ()

@end

@implementation GPGoodLittleThingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.firstPageURLString = @"http://api.liwushuo.com/v1/collections/22/posts?gender=1&generation=1&limit=20&offset=0";
    self.dataArrayName = @"posts";
    self.title = @"每日十件美好小物";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
}

@end
