//
//  Observer1.m
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import "Observer1.h"

@interface Observer1 ()

@end

@implementation Observer1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self startReading];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (!_isReading) return;
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            _isReading = NO;
            //透過dispatch_async可以解決原本解析出圖片之後，介面要等很久才會反映的問題
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopReading];
                
                UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Observer2"];
                [self showDetailViewController:nextView sender:self];
                
            });
        }
        
    }
}
- (void)startReading {
    _isReading = YES;
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:CGRectMake(60,150,200,200)];
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
}


-(void)stopReading{
    [self.captureSession stopRunning];
    [_videoPreviewLayer removeFromSuperlayer];
    _videoPreviewLayer = nil;
    self.captureSession = nil;
}


-(void) setOutput:(NSString *)decodeString{
    NSLog(@"setOutput function");
    NSLog(@"data=%@",decodeString);
    //generateQRViewController *as = [[generateQRViewController alloc]init];
    //[self addChildViewController:as];
    //[self presentViewController:as animated:YES completion:^{}];
    //[_showdecoe setText:[NSString stringWithFormat:@"%@",decodeString]];
}
-(BOOL)prefersStatusBarHidden {
    
    return YES;
    
}
@end
