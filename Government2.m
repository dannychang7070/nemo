//
//  Government2.m
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import "Government2.h"

@interface Government2 ()

@end

@implementation Government2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //寫入資料(無法修改標題)
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath=[[rootPath stringByAppendingPathComponent:@"AppData"]stringByAppendingString:@".plist"];
    NSMutableDictionary *dict=[[NSDictionary dictionaryWithContentsOfFile:plistPath]mutableCopy];
    self.title=[dict objectForKey:@"account"];
    server=[dict objectForKey:@"server"];
    governmentCheck=[dict objectForKey:@"governmentCheck"];
    
    list=[NSMutableArray arrayWithArray:[governmentCheck componentsSeparatedByString:@"_"]];
    
    NSString *connect1 = [NSString stringWithFormat:@"http://%@/nemo_php/getVoyage.php?account=%@&startDate=%@",server,[list objectAtIndex:0],[list objectAtIndex:1]];
    NSString *connect1_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect1]encoding:NSUTF8StringEncoding error:nil ];
    connect1_return=[self stringByStrippingHTML:connect1_return];
    connect1_return=[connect1_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    list2=[NSMutableArray arrayWithArray:[connect1_return componentsSeparatedByString:@","]];
    if ([list2 count]>1) {
        _ctno.text=[list2 objectAtIndex:0];
        _imo.text=[list2 objectAtIndex:1];
        _shipName.text=[list2 objectAtIndex:2];
        _shipNameEn.text=[list2 objectAtIndex:3];
        _shipType.text=[list2 objectAtIndex:4];
        _shipTonn.text=[list2 objectAtIndex:5];
        _startDate_O.text=[list2 objectAtIndex:6];
        _fishZone_O.text=[list2 objectAtIndex:7];
        _fishType_O.text=[list2 objectAtIndex:8];
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
- (IBAction)send:(UIButton *)sender {
    NSString *connect2 = [NSString stringWithFormat:@"http://%@/nemo_php/updateVoyage.php?account=%@&startDate=%@",server,[list objectAtIndex:0],[list objectAtIndex:1]];
    NSString *connect2_return = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:connect2]encoding:NSUTF8StringEncoding error:nil ];
    connect2_return=[self stringByStrippingHTML:connect2_return];
    connect2_return=[connect2_return stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"GovernmentTable"];
    [self showDetailViewController:nextView sender:self];

}

- (IBAction)cancel:(UIButton *)sender {
    UIViewController *nextView=[self.storyboard instantiateViewControllerWithIdentifier:@"GovernmentTable"];
    [self showDetailViewController:nextView sender:self];
}
@end
