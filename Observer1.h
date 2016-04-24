//
//  Observer1.h
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>//for QR code scan
@interface Observer1 : UIViewController<AVCaptureMetadataOutputObjectsDelegate>{
    UILabel *caption1,*caption2;
    UIImageView *QRcodeIcon;
    UIImageView *scanView;
    UIImageView *bar;
    UITextField *enterCodefield;
    UIButton *sendEnterCode,*startScan;
    NSString *server,*account;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL isReading;
-(void)stopReading;
@end
