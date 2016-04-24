//
//  Ship3.m
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import "Ship3.h"

@interface Ship3 ()

@end

@implementation Ship3

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
    //取得該次航行的所有漁獲
    NSString *connect2 = [NSString stringWithFormat:@"http://%@/nemo_php/allFish.php?account=%@&voyage=%@",server,account,voyage];
    NSString *connect2_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect2]encoding:NSUTF8StringEncoding error:nil ];
    connect2_return=[self stringByStrippingHTML:connect2_return];
    connect2_return=[connect2_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];

    if ([connect2_return isEqualToString:@"No FishDetail"]) {
        list = [[NSMutableArray alloc] init];
        [list addObject:@"沒有歷史漁獲"];
    }
    else{
        list=[NSMutableArray arrayWithArray:[connect2_return componentsSeparatedByString:@","]];
    }
    //設定是否出現返航按鈕
    NSString *connect3 = [NSString stringWithFormat:@"http://%@/nemo_php/checkVoyageType.php?account=%@&voyage=%@",server,account,voyage];
    NSString *connect3_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect3]encoding:NSUTF8StringEncoding error:nil ];
    connect3_return=[self stringByStrippingHTML:connect3_return];
    connect3_return=[connect3_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    NSLog(@"%@",connect3);
    NSLog(@"%@",connect3_return);
    if ([connect3_return length]>2) {
        _GoHome_O.hidden=YES;
        [_newfish_O setTitle:@"本航次已返航" forState:UIControlStateNormal];
        _newfish_O.userInteractionEnabled=NO;

    }
    else{
        [_newfish_O setTitle:@"新增漁獲" forState:UIControlStateNormal];
    }
    //設定本次總漁獲數
    NSString *connect4 = [NSString stringWithFormat:@"http://%@/nemo_php/checkVoyageTotalTonn.php?account=%@&startDate=%@",server,account,voyage];
    
    NSString *connect4_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect4]encoding:NSUTF8StringEncoding error:nil ];
    connect4_return=[self stringByStrippingHTML:connect4_return];
    connect4_return=[connect4_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    if ([connect4_return length]>0) {
        _tonnText_O.text=connect4_return;
    }
    else{
        _tonnText_O.text=@"0";
    }
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

- (IBAction)GoHome:(UIButton *)sender {
    //更新本航次的endDate
    NSString *connect5 = [NSString stringWithFormat:@"http://%@/nemo_php/endVoyage.php?account=%@&startDate=%@",server,account,voyage];
    NSLog(@"%@",connect5);
    NSString *connect5_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect5]encoding:NSUTF8StringEncoding error:nil ];
    connect5_return=[self stringByStrippingHTML:connect5_return];
    connect5_return=[connect5_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    //跳回首頁
    UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Ship1"];
    [self showDetailViewController:nextView sender:self];
}
- (IBAction)newFish:(id)sender {
    //新增漁獲頁面(ship4)
    UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Ship4"];
    [self showDetailViewController:nextView sender:self];
}

- (IBAction)cancel:(UIButton *)sender {
    UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Ship1"];
    [self showDetailViewController:nextView sender:self];
}
// 傳回有多少區段
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// 傳回每個區段要顯示多少列
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger n = 0;
    
    switch (section) {
        case 0:
            n = [list count];
            break;
            

    }
    return n;
}


// 設定每個區段的表頭資料，這個方法為非必要方法
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    
    switch (section) {
        case 0:
            header = @"歷史漁獲";
            break;
            
    }
    return header;
}


// 準備儲存格中的資料，當然必須區分出是哪一個區段的儲存格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indicator = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indicator];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indicator];
        
    }
    
    // 區分顯示區段 開始
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [list objectAtIndex:indexPath.row];
            break;
            
    }
    // 區分顯示區段 結束
    
    return cell;
}
//得知使用者點選了哪一個
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tableString;
    switch (indexPath.section) {
        case 0:
            tableString=[list objectAtIndex:indexPath.row];
            [self checkTableString:tableString];
            break;
    }
    //NSLog(@"%@",tableView);
    //NSLog(@"%@",[list objectAtIndex:indexPath.row]);
}
-(void) checkTableString:(NSString *)tableString{
    NSLog(@"%@",tableString);
    if ([tableString isEqualToString:@"沒有歷史漁獲"]) {
        return;
    }
    //寫入資料
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath=[[rootPath stringByAppendingPathComponent:@"AppData"]stringByAppendingString:@".plist"];
    NSMutableDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath]mutableCopy];
    [dict setObject:tableString forKey:@"fishDetail"];
    [dict writeToFile:plistPath atomically:YES];
    
    UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Ship5"];
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
-(BOOL)prefersStatusBarHidden {
    
    return YES;
    
}
@end
