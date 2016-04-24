//
//  Ship4.h
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface Ship4 : UIViewController<CLLocationManagerDelegate>{
    CLLocationManager *location;
    NSString *server,*account;

}
@property (weak, nonatomic) IBOutlet UILabel *VoyageNo_O;
@property (weak, nonatomic) IBOutlet UILabel *GPS_O;
- (IBAction)textField_Exit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *fishType_O;
@property (weak, nonatomic) IBOutlet UITextField *AllWeight_O;
@property (weak, nonatomic) IBOutlet UITextField *temprature_O;
@property (weak, nonatomic) IBOutlet UITextField *dapth_O;
@property (weak, nonatomic) IBOutlet UITextField *salonity_O;
@property (weak, nonatomic) IBOutlet UITextField *do_O;
@property (weak, nonatomic) IBOutlet UIImageView *QRcode_O;

- (IBAction)send:(UIButton *)sender;
- (IBAction)cancel:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *allWeight_A_O;
@property (weak, nonatomic) IBOutlet UITextField *temprature_A_O;
@property (weak, nonatomic) IBOutlet UITextField *depth_A_O;

@end
