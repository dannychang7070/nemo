//
//  Ship3.h
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ship3 : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSString *server,*account,*voyage;
    NSMutableArray *list;
}
@property (weak, nonatomic) IBOutlet UILabel *tonnText_O;
@property (weak, nonatomic) IBOutlet UIButton *GoHome_O;
- (IBAction)GoHome:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *newfish_O;
- (IBAction)newFish:(id)sender;
- (IBAction)cancel:(UIButton *)sender;

@end
