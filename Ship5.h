//
//  Ship5.h
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ship5 : UIViewController{
    NSString *server,*account,*voyage;
    NSMutableArray *list;

}
@property (weak, nonatomic) IBOutlet UILabel *VoyageNo_O;
@property (weak, nonatomic) IBOutlet UILabel *GPS_O;
@property (weak, nonatomic) IBOutlet UILabel *fishType_O;

@property (weak, nonatomic) IBOutlet UILabel *allWeight_O;
@property (weak, nonatomic) IBOutlet UILabel *temprature_O;
@property (weak, nonatomic) IBOutlet UILabel *dapth_O;
@property (weak, nonatomic) IBOutlet UILabel *salonity_O;
@property (weak, nonatomic) IBOutlet UILabel *do_O;

@property (weak, nonatomic) IBOutlet UIImageView *QRcode_O;
- (IBAction)cancel:(UIButton *)sender;
/*
@property (weak, nonatomic) IBOutlet UITextField *allWeight_A_O;
@property (weak, nonatomic) IBOutlet UITextField *temprature_A_O;
@property (weak, nonatomic) IBOutlet UITextField *depth_A_O;*/
@end
