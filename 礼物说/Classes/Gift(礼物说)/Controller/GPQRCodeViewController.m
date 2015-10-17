//
//  GPQRCodeViewController.m
//  礼物说
//
//  Created by tripleCC on 15/10/16.
//  Copyright © 2015年 tripleCC. All rights reserved.
//

#import "GPQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface GPQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *scanLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanLineTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *QRCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *barCodeButton;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureMetadataOutput *outputMetadata;
@property (weak, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureDeviceInput *inputDevice;
@property (weak, nonatomic) CALayer *boarderLayer;
@end

@implementation GPQRCodeViewController

#pragma mark 懒加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSession];
    [self setupNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupLayers];
    [self startScan];
    [self startAnimation];
}

- (void)setupNav {
    self.navigationItem.title = @"扫码留声";
}

- (void)setupSession {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.inputDevice = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    self.outputMetadata = [[AVCaptureMetadataOutput alloc] init];
    
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canAddInput:self.inputDevice] && [self.session canAddOutput:self.outputMetadata]) {
        [self.session addInput:self.inputDevice];
        [self.session addOutput:self.outputMetadata];
        
        // 扫描范围
        self.outputMetadata.rectOfInterest = CGRectMake((124)/TPCScreenH,((TPCScreenW-250)/2)/TPCScreenW,250/TPCScreenH,250/TPCScreenW);
        self.outputMetadata.metadataObjectTypes = self.outputMetadata.availableMetadataObjectTypes;
        [self.outputMetadata setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
}

- (void)setupLayers {
    CALayer *boarderLayer = [[CALayer alloc] init];
    boarderLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:boarderLayer atIndex:0];
    self.boarderLayer = boarderLayer;
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    previewLayer.frame = self.view.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    self.previewLayer = previewLayer;
}

- (IBAction)QRCode:(id)sender {
    
}

- (IBAction)barCode:(id)sender {
    
}

- (IBAction)help:(id)sender {
}

- (void)startAnimation {
    self.scanLineTopConstraint.constant = -self.containerHeightConstraint.constant;
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:2.0 animations:^{
        self.scanLineTopConstraint.constant = self.containerHeightConstraint.constant;
        [UIView setAnimationRepeatCount:MAXFLOAT];
        [self.view layoutIfNeeded];
    }];
}

- (void)startScan {
    [self.session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    [self clearBoarderLayer];
    
    for (id objc in metadataObjects) {
        if ([objc isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            AVMetadataMachineReadableCodeObject *dataObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:(AVMetadataObject *)objc];
            [self drawBoarderLayerWithDataObject:dataObject];
        }
    }
}

- (void)clearBoarderLayer {
    [self.boarderLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (void)drawBoarderLayerWithDataObject:(AVMetadataMachineReadableCodeObject *)dataObject {
    if (!dataObject.corners.count) return;
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.lineWidth = 1;
    layer.strokeColor = [UIColor orangeColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = [self boarderPathWithBoarders:dataObject.corners];
    
    [self.boarderLayer addSublayer:layer];
}

- (CGPathRef)boarderPathWithBoarders:(NSArray *)boarders {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointZero;
    
    NSInteger index = 0;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)boarders[index++], &point);
    [path moveToPoint:point];
    
    while (index < boarders.count) {
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)boarders[index++], &point);
        [path addLineToPoint:point];
    }
    
    [path closePath];
    
    return path.CGPath;
}
@end
