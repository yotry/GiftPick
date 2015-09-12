//
//  GPSearchGiftHeader.m
//  礼物说
//
//  Created by heew on 15/1/16.
//  Copyright (c) 2014年 giftTalk All rights reserved.
//

#import "GPSearchGiftHeader.h"

@implementation GPSearchGiftHeader

#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 1; i++) {
        NSString *imageName = [NSString stringWithFormat:@"box_%02zd", i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [image imageByScalingToSize:CGSizeMake(40, 40)];
        [idleImages addObject:newImage];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 2; i <= 5; i++) {
        NSString *imageName = [NSString stringWithFormat:@"box_%02zd", i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [image imageByScalingToSize:CGSizeMake(40, 40)];
        [refreshingImages addObject:newImage];
    }
    [self setImages:refreshingImages forState:MJRefreshStateWillRefresh];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *startImages = [NSMutableArray array];
    NSString *imageName = [NSString stringWithFormat:@"heart"];
    UIImage *image = [UIImage imageNamed:imageName];
    
    UIGraphicsBeginImageContext(image.size);
    [image drawAtPoint:CGPointMake(0, image.size.height * 0.5) blendMode:kCGBlendModeNormal alpha:0.5];
    UIImage *image1 = [UIGraphicsGetImageFromCurrentImageContext() imageByScalingToSize:CGSizeMake(40, 40)];
    [startImages addObject:image1];
    UIGraphicsEndImageContext();
    
    
    UIGraphicsBeginImageContext(image.size);
    [image drawAtPoint:CGPointMake(0, image.size.height * 0.3) blendMode:kCGBlendModeNormal alpha:0.7];
    UIImage *image3 = [UIGraphicsGetImageFromCurrentImageContext() imageByScalingToSize:CGSizeMake(40, 40)];
    [startImages addObject:image3];
    UIGraphicsEndImageContext();
    
    
    UIGraphicsBeginImageContext(image.size);
    [image drawAtPoint:CGPointMake(0, image.size.height * 0.2) blendMode:kCGBlendModeNormal alpha:0.8];
    UIImage *image4 = [UIGraphicsGetImageFromCurrentImageContext() imageByScalingToSize:CGSizeMake(40, 40)];
    [startImages addObject:image4];
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(image.size);
    [image drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:1];
    UIImage *image6 = [UIGraphicsGetImageFromCurrentImageContext() imageByScalingToSize:CGSizeMake(40, 40)];
    [startImages addObject:image6];
    UIGraphicsEndImageContext();
    
    [self setImages:startImages forState:MJRefreshStateRefreshing];
    
}

@end

@implementation UIImage (Size)

- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}
@end
