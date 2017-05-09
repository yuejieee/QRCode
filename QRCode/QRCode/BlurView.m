//
//  BlurView.m
//  QRCode
//
//  Created by Kingpin on 2017/5/8.
//  Copyright © 2017年 yuejieee. All rights reserved.
//

#import "BlurView.h"

@implementation BlurView

- (void)drawRect:(CGRect)rect {
    CGFloat width = rect.size.width - 140;
    CGFloat pointX = rect.size.width - 70;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 70, 150);
    CGContextAddLineToPoint(context, pointX, 150);
    CGContextAddLineToPoint(context, pointX, 150 + width);
    CGContextAddLineToPoint(context, 70, 150 + width);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
}

@end
