//
//  Ship4.m
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import "Ship4.h"

@interface Ship4 ()

@end

@implementation Ship4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //取得漁獲序號
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath=[[rootPath stringByAppendingPathComponent:@"AppData"]stringByAppendingString:@".plist"];
    NSMutableDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath]mutableCopy];
    server=[dict objectForKey:@"server"];
    account=[dict objectForKey:@"account"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *todayStr = [dateFormatter stringFromDate:[NSDate date]];
    
    _VoyageNo_O.text=[NSString stringWithFormat:@"%@_%@_%@",[dict objectForKey:@"account"],[dict objectForKey:@"voyage"],todayStr];
    _GPS_O.text=@"123.2145-23.3221";
    //取得GPS
    location = [[CLLocationManager alloc] init];
    location.delegate = self;
    // 開啟計算目前行動裝置所在位置的功能
    [location requestWhenInUseAuthorization];
    [location startUpdatingLocation];
    
    //產生QR code
    CIImage *qrCode = [self createQRForString:_VoyageNo_O.text];
    
    UIImage *qrCodeImg = [self createNonInterpolatedUIImageFromCIImage:qrCode withScale:2*[[UIScreen mainScreen] scale]];
    _QRcode_O.image=qrCodeImg;
    
    UIImageView *bg=[[UIImageView alloc]initWithImage: [UIImage imageNamed:@"Nemo-G1&S1&S3&O1BG.png"]];
    bg.frame=self.view.frame;
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated{
    // 開啟計算目前行動裝置所在位置的功能
    [location stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *c = [locations objectAtIndex:0];
    _GPS_O.text=[NSString stringWithFormat:@"%f-%f", c.coordinate.latitude, c.coordinate.longitude];
    //[location stopUpdatingLocation];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)prefersStatusBarHidden {
    
    return YES;
    
}
- (IBAction)textField_Exit:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)send:(UIButton *)sender {
    //單位轉換
    double newAllWeight=[_AllWeight_O.text doubleValue];
    if ([_allWeight_A_O.text isEqualToString:@"kg"]) {
        newAllWeight=newAllWeight/1000;
    }
    else if ([_allWeight_A_O.text isEqualToString:@"kati"]){
        newAllWeight=newAllWeight*0.0006;
    }
    else if([_allWeight_A_O.text isEqualToString:@"g"]){
        newAllWeight=newAllWeight/1000000;
    }
    else if([_allWeight_A_O.text isEqualToString:@"tael"]){
        newAllWeight=newAllWeight*0.00004;
    }
    else if ([_allWeight_A_O.text isEqualToString:@"lb"]){
        newAllWeight=newAllWeight*0.00045;
    }
    else if ([_allWeight_A_O.text isEqualToString:@"oz"]){
        newAllWeight=newAllWeight*0.00003;
    }
    double newTemprature=[_temprature_O.text doubleValue];
    if ([_temprature_A_O.text isEqualToString:@"f"]) {
        newTemprature=(newTemprature-32)*(5/9);
    }
    double newDepth=[_dapth_O.text doubleValue];
    if ([_depth_A_O.text isEqualToString:@"ft"]) {
        newDepth=newDepth*0.3048;
    }
    else if ([_depth_A_O.text isEqualToString:@"in"]){
        newDepth=newDepth*0.07620762;
    }
    else if([_depth_A_O.text isEqualToString:@"cm"]){
        newDepth=newDepth/100;
    }
    //更新到資料庫
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath=[[rootPath stringByAppendingPathComponent:@"AppData"]stringByAppendingString:@".plist"];
    NSMutableDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath]mutableCopy];
    NSString *voyage=[dict objectForKey:@"voyage"];
    
    NSString *connect1 = [NSString stringWithFormat:@"http://%@/nemo_php/newFishDetail.php?account=%@&startDate=%@&no=%@&GPS=%@&fishType=%@&allWeight=%f&temprature=%f&dapth=%f&salinity=%@&do=%@",server,account,voyage,_VoyageNo_O.text,_GPS_O.text,_fishType_O.text,newAllWeight,newTemprature,newDepth,_salonity_O.text,_do_O.text];
    NSLog(@"%@",connect1);
    NSString *connect1_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect1]encoding:NSUTF8StringEncoding error:nil ];
    connect1_return=[self stringByStrippingHTML:connect1_return];
    connect1_return=[connect1_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Ship3"];
    [self showDetailViewController:nextView sender:self];

}
- (NSString *) stringByStrippingHTML:(NSString *)s {
    NSString *retVal;
    @autoreleasepool {
        NSRange r;
        
        while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
            s = [s stringByReplacingCharactersInRange:r withString:@""];
        }
        retVal = [s copy];
    }
    // pool is drained, release s and all temp
    // strings created by stringByReplacingCharactersInRange
    return retVal;
}
- (IBAction)cancel:(UIButton *)sender {
    UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Ship3"];
    [self showDetailViewController:nextView sender:self];
}
- (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}
- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return scaledImage;
}
@end
