## Description
比较常用的二维码扫描控件封装，利用AVFundation实现，比较简单。
## Usage
* 直接`#import "QRCode"`之后设置frame，addSubview即可。
* 识别完成后回调`QRCodeDidOutputObjects:(NSArray *)Objects`，需要设置`QRCodeDelegate`