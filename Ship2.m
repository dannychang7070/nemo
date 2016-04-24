//
//  Ship2.m
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import "Ship2.h"

@interface Ship2 ()

@end

@implementation Ship2

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
    //取得船籍基本資料
    NSString *connect2 = [NSString stringWithFormat:@"http://%@/nemo_php/shipData.php?account=%@",server,account];
    NSString *connect2_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect2]encoding:NSUTF8StringEncoding error:nil ];
    connect2_return=[self stringByStrippingHTML:connect2_return];
    connect2_return=[connect2_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    NSLog(@"%@",connect2_return);
    if ([connect2_return isEqualToString:@"No Number"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系統資訊"message:@"資料錯誤" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        list=[NSMutableArray arrayWithArray:[connect2_return componentsSeparatedByString:@","]];
        NSLog(@"%@",list);
        _ctno.text=[list objectAtIndex:0];
        _imo.text=[list objectAtIndex:1];
        _shipName.text=[list objectAtIndex:2];
        _shipNameEn.text=[list objectAtIndex:3];
        _shipType.text=[list objectAtIndex:4];
        _shipTonn.text=[list objectAtIndex:5];
    }
    //設定點擊日期之後會跳出日期可選擇
    //ps. 建立 UIDatePicker
    datePicker = [[UIDatePicker alloc]init];
    datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    datePicker.locale = datelocale;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    //ps. 將 UITextField 的 inputView 設定成 UIDatePicker，則原本會跳出鍵盤的地方 就改成選日期了
    _date.inputView = datePicker;
    
    //ps. 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    //ps. 選取日期完成鈕 並給他一個 selector
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                                                          action:@selector(cancelPicker)];
    //ps. 把按鈕加進 UIToolbar
    toolBar.items = [NSArray arrayWithObject:right];
    //ps. 以下這行也是重點 (螢光筆畫兩行)
    //ps. 原本應該是鍵盤上方附帶內容的區塊 改成一個 UIToolbar 並加上完成鈕
    _date.inputAccessoryView = toolBar;

    UIImageView *bg=[[UIImageView alloc]initWithImage: [UIImage imageNamed:@"Nemo-G1&S1&S3&O1BG.png"]];
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
-(void) cancelPicker {
    // endEditing: 是結束編輯狀態的 method
    if ([self.view endEditing:NO]) {
        // 以下幾行是測試用 可以依照自己的需求增減屬性
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyyMMdd" options:0 locale:datelocale];
        [formatter setDateFormat:dateFormat];
        [formatter setLocale:datelocale];
        // 將選取後的日期 填入 UITextField
        _date.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)send:(UIButton *)sender {
    int datelen=(int)_date.text.length;
    int fishZoneLen=(int)_fishZone_O.text.length;
    int fishTypeLen=(int)_fishType_O.text.length;
    if (datelen>2 && fishZoneLen>2 && fishTypeLen>2) {
        NSString *connect4 = [NSString stringWithFormat:@"http://%@/nemo_php/newVoyage.php?account=%@&startDate=%@&fishZone=%@&fishType=%@",server,account,_date.text,_fishZone_O.text,_fishType_O.text];
        NSLog(@"%@",connect4);
        NSString *connect4_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect4]encoding:NSUTF8StringEncoding error:nil ];
        connect4_return=[self stringByStrippingHTML:connect4_return];
        connect4_return=[connect4_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        //跳回首頁
        UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Ship1"];
        [self showDetailViewController:nextView sender:self];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"系統資訊"message:@"資料欄位未填寫" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)cancel:(UIButton *)sender {
    UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Ship1"];
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

- (IBAction)TextFiled_Exit:(UITextField *)sender {
    [sender resignFirstResponder];
}
@end
