//
//  QRCode.h
//  QRCode
//
//  Created by Kingpin on 2017/5/8.
//  Copyright © 2017年 yuejieee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureOutput;

@protocol QRCodeDelegate <NSObject>

- (void)QRCodeDidOutputObjects:(NSArray *)Objects;

@end

@interface QRCode : UIView

@property (nonatomic, weak) id<QRCodeDelegate> delegate;

@end
