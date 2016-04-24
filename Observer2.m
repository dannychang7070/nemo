//
//  Observer2.m
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import "Observer2.h"

@interface Observer2 ()

@end

@implementation Observer2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //寫入資料
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath=[[rootPath stringByAppendingPathComponent:@"AppData"]stringByAppendingString:@".plist"];
    NSMutableDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath]mutableCopy];
    self.title=[dict objectForKey:@"account"];
    server=[dict objectForKey:@"server"];
    account=[dict objectForKey:@"account"];
    voyage=[dict objectForKey:@"voyage"];
    NSString *fishDatailNo=[dict objectForKey:@"fishDetail"];
    //取得該次航行的所有漁獲
    NSString *connect2 = [NSString stringWithFormat:@"http://%@/nemo_php/getFishDetail2.php?no=%@",server,fishDatailNo];
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

- (IBAction)Text_Exit:(UITextField *)sender {
    [sender resignFirstResponder];

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
-(BOOL)prefersStatusBarHidden {
    
    return YES;
    
}
- (IBAction)cancel:(UIButton *)sender {
    UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Observer1"];
    [self showDetailViewController:nextView sender:self];
}
@end
