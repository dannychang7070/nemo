//
//  ViewController.h
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    
}

- (IBAction)account_T_Eixt:(id)sender;
- (IBAction)password_T_Exit:(id)sender;
- (IBAction)login_A:(UIButton *)sender;
- (IBAction)server_T_Exit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *account_O;
@property (weak, nonatomic) IBOutlet UITextField *password_O;
@property (weak, nonatomic) IBOutlet UITextField *server_O;

@end

