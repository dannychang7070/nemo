//
//  Government2.h
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Government2 : UIViewController{
    NSString *server,*account,*governmentCheck;
    NSMutableArray *list,*list2;
}
@property (weak, nonatomic) IBOutlet UILabel *ctno;
@property (weak, nonatomic) IBOutlet UILabel *imo;
@property (weak, nonatomic) IBOutlet UILabel *shipName;
@property (weak, nonatomic) IBOutlet UILabel *shipNameEn;
@property (weak, nonatomic) IBOutlet UILabel *shipType;
@property (weak, nonatomic) IBOutlet UILabel *shipTonn;
@property (weak, nonatomic) IBOutlet UILabel *startDate_O;
@property (weak, nonatomic) IBOutlet UILabel *fishZone_O;
@property (weak, nonatomic) IBOutlet UILabel *fishType_O;
- (IBAction)send:(UIButton *)sender;
- (IBAction)cancel:(UIButton *)sender;



@end
