//
//  Ship1.h
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ship1 : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSString *server,*account;
    NSMutableArray *list;
    NSMutableArray *another_list;
}

@end
