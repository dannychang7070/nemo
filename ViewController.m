//
//  ViewController.m
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //檢查plist檔案是否已經複製於PhoneDoctor的文件資料夾中
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath=[[rootPath stringByAppendingPathComponent:@"AppData"]stringByAppendingString:@".plist"];
    if (![fileManager fileExistsAtPath: plistPath]){
        NSString *file = [[NSBundle mainBundle] pathForResource:@"AppData" ofType:@"plist"];
        [fileManager copyItemAtPath:file toPath:plistPath error:nil];
        NSMutableDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath]mutableCopy];
        /*一定要加上mutableCopy，否則會出錯，類似先複製的想法，否則之後無法修改值*/
        [dict writeToFile:plistPath atomically:YES];
    }
    UIImageView *bg=[[UIImageView alloc]initWithImage: [UIImage imageNamed:@"Nemo-LoginBG.png"]];
    bg.frame=self.view.frame;
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden {
    
    return YES;
    
}
- (IBAction)account_T_Eixt:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)password_T_Exit:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)server_T_Exit:(id)sender {
    [sender resignFirstResponder];
    
}
- (IBAction)login_A:(UIButton *)sender {
    int account=(int)_account_O.text.length;
    int password=(int)_password_O.text.length;
    int server=(int)_server_O.text.length;
    if ((account<2 || password <2 || server<2)){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系統資訊"message:@"資料欄位未填寫" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        NSString *connect1 = [NSString stringWithFormat:@"http://%@/nemo_php/login.php?account=%@&password=%@",_server_O.text,_account_O.text,_password_O.text];
        
        NSString *connect1_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect1]encoding:NSUTF8StringEncoding error:nil ];
        connect1_return=[self stringByStrippingHTML:connect1_return];
        connect1_return=[connect1_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        
        
        if ([connect1_return isEqualToString:@"Finish_商業漁船"]) {
            //寫入資料
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *plistPath=[[rootPath stringByAppendingPathComponent:@"AppData"]stringByAppendingString:@".plist"];
            NSMutableDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath]mutableCopy];
            [dict setObject:_account_O.text forKey:@"account"];
            [dict setObject:_server_O.text forKey:@"server"];
            [dict writeToFile:plistPath atomically:YES];
            UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Ship1"];
            [self showDetailViewController:nextView sender:self];
        }
        else if ([connect1_return isEqualToString:@"Finish_政府單位"]){
            NSLog(@"政府單位");
            //寫入資料
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *plistPath=[[rootPath stringByAppendingPathComponent:@"AppData"]stringByAppendingString:@".plist"];
            NSMutableDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath]mutableCopy];
            [dict setObject:_account_O.text forKey:@"account"];
            [dict setObject:_server_O.text forKey:@"server"];

            [dict writeToFile:plistPath atomically:YES];
            UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"GovernmentTable"];
            [self showDetailViewController:nextView sender:self];
        }
        else if ([connect1_return isEqualToString:@"Finish_觀察單位"] || [connect1_return isEqualToString:@"Finish_研究單位"]){
            //寫入資料
            
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *plistPath=[[rootPath stringByAppendingPathComponent:@"AppData"]stringByAppendingString:@".plist"];
            NSMutableDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath]mutableCopy];
            [dict setObject:_account_O.text forKey:@"account"];
            [dict setObject:_server_O.text forKey:@"server"];
            [dict setObject:@"CT8-1234_2016/05/24_20160424102404" forKey:@"fishDetail"];
            
            [dict writeToFile:plistPath atomically:YES];
            
            UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Observer2"];
            [self showDetailViewController:nextView sender:self];
        }
        else{
            //NSLog(@"%@",[connect1_return stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            
            NSLog(@"登入失敗");
            NSLog(@"%@",connect1_return);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系統資訊"message:@"登入失敗" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
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

@end
