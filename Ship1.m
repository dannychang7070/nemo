//
//  Ship1.m
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import "Ship1.h"

@interface Ship1 ()

@end

@implementation Ship1

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
    //取得目前時間，判斷有沒有航行中(未核可)
    NSString *connect1 = [NSString stringWithFormat:@"http://%@/nemo_php/noEndDate.php?account=%@",server,account];
    NSString *connect1_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect1]encoding:NSUTF8StringEncoding error:nil ];
    connect1_return=[self stringByStrippingHTML:connect1_return];
    connect1_return=[connect1_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    if ([connect1_return isEqualToString:@"No on Voyage"]) {
        NSLog(@"要顯示新增航次");
        list = [[NSMutableArray alloc] init];
        [list addObject:@"新增航次"];
    }
    else{
        list=[NSMutableArray arrayWithArray:[connect1_return componentsSeparatedByString:@","]];
    }
    //取得該船的歷史紀錄
    NSString *connect2 = [NSString stringWithFormat:@"http://%@/nemo_php/allVoyage.php?account=%@",server,account];
    NSString *connect2_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect2]encoding:NSUTF8StringEncoding error:nil ];
    connect2_return=[self stringByStrippingHTML:connect2_return];
    connect2_return=[connect2_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    another_list=[NSMutableArray arrayWithArray:[connect2_return componentsSeparatedByString:@","]];

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// 傳回有多少區段
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


// 傳回每個區段要顯示多少列
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger n = 0;
    
    switch (section) {
        case 0:
            n = [list count];
            break;
            
        case 1:
            n = [another_list count];
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
            header = @"航行中";
            break;
            
        case 1:
            header = @"歷史航次";
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
            
        case 1:
            cell.textLabel.text = [another_list objectAtIndex:indexPath.row];
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
            
        case 1:
            tableString=[another_list objectAtIndex:indexPath.row];
            [self goDetail:tableString];
            break;
    }
    //NSLog(@"%@",tableView);
    //NSLog(@"%@",[list objectAtIndex:indexPath.row]);
}
-(void) checkTableString:(NSString *)tableString{
    NSMutableArray *voyage_list=[NSMutableArray arrayWithArray:[tableString componentsSeparatedByString:@"_"]];
    NSString *check=0;
    if ([voyage_list count]>=2) {
        check=[voyage_list objectAtIndex:2];
    }
    if ([tableString isEqualToString:@"新增航次"]) {
        NSLog(@"新增航次");
        [self goNew];
    }
    else if([check isEqualToString:@"已核可"]){
        NSLog(@"已核可");
        [self goDetail:tableString];
    }
    else{
        NSLog(@"審核中，不反應");
    }
}
-(void)goNew{
    
    UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Ship2"];
    [self showDetailViewController:nextView sender:self];
}
-(void)goDetail :(NSString *) temp{
    //取得該航次的開始日期(index1)
    NSMutableArray *voyage_list=[NSMutableArray arrayWithArray:[temp componentsSeparatedByString:@"_"]];
    //寫入資料
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath=[[rootPath stringByAppendingPathComponent:@"AppData"]stringByAppendingString:@".plist"];
    NSMutableDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath]mutableCopy];
    [dict setObject:[voyage_list objectAtIndex:1] forKey:@"voyage"];
    
    
    [dict writeToFile:plistPath atomically:YES];
    
    UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Ship3"];
    [self showDetailViewController:nextView sender:self];
}
@end
