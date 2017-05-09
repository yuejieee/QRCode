//
//  ViewController.m
//  QRCode
//
//  Created by Kingpin on 2017/5/8.
//  Copyright © 2017年 yuejieee. All rights reserved.
//

#import "ViewController.h"
#import "QRCode.h"

@interface ViewController () <QRCodeDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QRCode *qr = [QRCode new];
    [self.view addSubview:qr];
    qr.frame = self.view.frame;
    qr.delegate = self;
}

- (void)QRCodeDidOutputObjects:(NSArray *)Objects {
    NSLog(@"%@", Objects);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
