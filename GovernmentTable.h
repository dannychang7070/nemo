//
//  GovernmentTable.h
//  nemo
//
//  Created by 陳 志鴻 on 2016/4/23.
//  Copyright (c) 2016年 陳 志鴻. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GovernmentTable : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    NSString *server,*account;
    NSMutableArray *list;
}
@end
