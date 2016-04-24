//
//  Observer2.h
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Observer2 : UIViewController{
    NSMutableArray *list;
    NSString *server,*account,*voyage;

}
@property (weak, nonatomic) IBOutlet UILabel *VoyageNo_O;
@property (weak, nonatomic) IBOutlet UILabel *GPS_O;
@property (weak, nonatomic) IBOutlet UILabel *fishType_O;

@property (weak, nonatomic) IBOutlet UILabel *allWeight_O;
@property (weak, nonatomic) IBOutlet UILabel *temprature_O;
@property (weak, nonatomic) IBOutlet UILabel *dapth_O;
@property (weak, nonatomic) IBOutlet UILabel *salonity_O;
@property (weak, nonatomic) IBOutlet UILabel *do_O;
- (IBAction)Text_Exit:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UITextField *singleWeight;
@property (weak, nonatomic) IBOutlet UITextField *singleLeng;
@property (weak, nonatomic) IBOutlet UITextField *singleAge;
@property (weak, nonatomic) IBOutlet UITextField *singleWeight_A;
@property (weak, nonatomic) IBOutlet UITextField *singleLeng_A;
@property (weak, nonatomic) IBOutlet UITextField *singleAge_A;
- (IBAction)cancel:(UIButton *)sender;

@end
