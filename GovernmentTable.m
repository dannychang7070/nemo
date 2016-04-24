//
//  GovernmentTable.m
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import "GovernmentTable.h"

@interface GovernmentTable ()

@end

@implementation GovernmentTable

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //寫入資料(無法修改標題)
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath=[[rootPath stringByAppendingPathComponent:@"AppData"]stringByAppendingString:@".plist"];
    NSMutableDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath]mutableCopy];
    self.title=[dict objectForKey:@"account"];
    server=[dict objectForKey:@"server"];
    
    NSString *connect1 = [NSString stringWithFormat:@"http://%@/nemo_php/AllNoEndDate.php",server];
    NSLog(@"%@",connect1);
    NSString *connect1_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect1]encoding:NSUTF8StringEncoding error:nil ];
    connect1_return=[self stringByStrippingHTML:connect1_return];
    connect1_return=[connect1_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    NSLog(@"%@",connect1_return);
    if ([connect1_return isEqualToString:@"No on Voyage"]) {
        //NSLog(@"要顯示新增航次");
        list = [[NSMutableArray alloc] init];
        [list addObject:@"沒有待審核漁船"];
    }
    else{
        list=[NSMutableArray arrayWithArray:[connect1_return componentsSeparatedByString:@","]];
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
            header = @"待審漁船";
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
    if ([tableString isEqualToString:@"沒有待審核漁船"]) {
        return;
    }
    //取得該航次的開始日期(index1)
    
    //寫入資料
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath=[[rootPath stringByAppendingPathComponent:@"AppData"]stringByAppendingString:@".plist"];
    NSMutableDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath]mutableCopy];
    [dict setObject:tableString forKey:@"governmentCheck"];
    
    
    [dict writeToFile:plistPath atomically:YES];
    
    UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"Government2"];
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
