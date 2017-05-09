//
//  QRCode.m
//  QRCode
//
//  Created by Kingpin on 2017/5/8.
//  Copyright © 2017年 yuejieee. All rights reserved.
//

#import "QRCode.h"
#import "BlurView.h"
#import <AVFoundation/AVFoundation.h>

#define ScanWidth self.frame.size.width - 140

@interface QRCode () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) UIImageView *frameImgView;

@property (nonatomic, strong) UIImageView *lineImgView;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation QRCode

- (void)layoutSubviews {
    [super layoutSubviews];
    BlurView *bgView = [BlurView new];
    [self addSubview:bgView];
    bgView.frame = self.frame;
    
     self.frameImgView = [UIImageView new];
    [self addSubview:self.frameImgView];
    self.frameImgView.frame = CGRectMake(70, 150, ScanWidth, ScanWidth);
    self.frameImgView.image = [UIImage imageNamed:@"scanBg"];
    
    self.lineImgView = [UIImageView new];
    [self addSubview:self.lineImgView];
    self.lineImgView.image = [UIImage imageNamed:@"scanLine"];
    
    [self setupAnimated];
    [self setupAVPlayer];
}

- (void)setupAVPlayer {
    // 获取设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 创建输入流
    AVCaptureInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 创建输出流
    AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
    // 设置代理，并在主线程中刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue currentQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      output.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:self.frameImgView.frame];
                                                  }];
    // 初始化session来采集图像
    self.session = [AVCaptureSession new];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    // 添加输入
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    // 添加输出
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
        NSMutableArray *types = [NSMutableArray new];
        // 可识别的码类型
        // 二维码
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [types addObject:AVMetadataObjectTypeQRCode];
        }
//        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
//            [types addObject:AVMetadataObjectTypeEAN13Code];
//        }
//        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
//            [types addObject:AVMetadataObjectTypeEAN8Code];
//        }
//        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
//            [types addObject:AVMetadataObjectTypeCode128Code];
//        }
        output.metadataObjectTypes = types;
    }
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = [UIScreen mainScreen].bounds;
    [self.layer insertSublayer:self.previewLayer atIndex:0];
    // 启动会话
    [self.session startRunning];
}

- (void)setupAnimated {
    self.lineImgView.frame = CGRectMake(70, 160, ScanWidth, 2);
    [UIView animateWithDuration:3 animations:^{
        self.lineImgView.frame = CGRectMake(70, 140 + ScanWidth, ScanWidth, 2);
    } completion:^(BOOL finished) {
        [self setupAnimated];
    }];
}

#pragma mark - delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ([self.delegate respondsToSelector:@selector(QRCodeDidOutputObjects:)]) {
        [self.delegate QRCodeDidOutputObjects:metadataObjects];
    }
    [self.session stopRunning];
    [self.previewLayer removeFromSuperlayer];
}



@end
