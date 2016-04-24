//
//  Ship5.m
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import "Ship5.h"

@interface Ship5 ()

@end

@implementation Ship5

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //寫入資料(無法修改標題)
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath=[[rootPath stringByAppendingPathComponent:@"AppData"]stringByAppendingString:@".plist"];
    NSMutableDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath]mutableCopy];
    self.title=[dict objectForKey:@"account"];
    server=[dict objectForKey:@"server"];
    account=[dict objectForKey:@"account"];
    voyage=[dict objectForKey:@"voyage"];
    NSString *fishDatailNo=[dict objectForKey:@"fishDetail"];
    //取得該次航行的所有漁獲
    NSString *connect2 = [NSString stringWithFormat:@"http://%@/nemo_php/getFishDetail.php?fishDetailNo=%@&account=%@&startDate=%@",server,fishDatailNo,account,voyage];
    NSLog(@"%@",connect2);
    NSString *connect2_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect2]encoding:NSUTF8StringEncoding error:nil ];
    connect2_return=[self stringByStrippingHTML:connect2_return];
    connect2_return=[connect2_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    NSLog(@"%@",connect2_return);
    if ([connect2_return isEqualToString:@"No FishDetail"]) {
        NSLog(@"沒資料");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系統資訊"message:@"資料庫資料錯誤" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        NSLog(@"有資料");

        list=[NSMutableArray arrayWithArray:[connect2_return componentsSeparatedByString:@","]];
        NSLog(@"%@",list);
        
        _VoyageNo_O.text=[list objectAtIndex:0];
        _GPS_O.text=[list objectAtIndex:1];
        _fishType_O.text=[list objectAtIndex:2];
        _allWeight_O.text=[list objectAtIndex:3];
        _temprature_O.text=[list objectAtIndex:4];
        _dapth_O.text=[list objectAtIndex:5];
        _salonity_O.text=[list objectAtIndex:6];
        _do_O.text=[list objectAtIndex:7];
        
        //產生QR code
        CIImage *qrCode = [self createQRForString:_VoyageNo_O.text];
        
        UIImage *qrCodeImg = [self createNonInterpolatedUIImageFromCIImage:qrCode withScale:2*[[UIScreen mainScreen] scale]];
        _QRcode_O.image=qrCodeImg;
    }
    
    UIImageView *bg=[[UIImageView alloc]initWithImage: [UIImage imageNamed:@"Nemo-G1&S1&S3&O1BG.png"]];
    bg.frame=self.view.frame;
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
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
-(BOOL)prefersStatusBarHidden {
    
    return YES;
    
}
- (IBAction)cancel:(UIButton *)sender {
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
