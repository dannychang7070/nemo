//
//  Ship2.h
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ship2 : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSString *server,*account;
    NSMutableArray *list;
    UIDatePicker *datePicker;
    NSLocale *datelocale;


}
@property (weak, nonatomic) IBOutlet UILabel *ctno;
@property (weak, nonatomic) IBOutlet UILabel *imo;
@property (weak, nonatomic) IBOutlet UILabel *shipName;
@property (weak, nonatomic) IBOutlet UILabel *shipNameEn;
@property (weak, nonatomic) IBOutlet UILabel *shipType;
@property (weak, nonatomic) IBOutlet UILabel *shipTonn;
- (IBAction)send:(UIButton *)sender;
- (IBAction)cancel:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *fishType_O;
- (IBAction)TextFiled_Exit:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UITextField *fishZone_O;

@end
