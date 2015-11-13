//
//  MyHouseSourceViewController.h
//  YKHouse
//
//  Created by wjl on 14-10-15.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorkManager.h"
@interface MyHouseSourceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AFNetWorkManagerDelegate,UIAlertViewDelegate>
{
    UITableView *myHouseSourceTableView;
    NSMutableArray *_myHouseSource;
    AFNetWorkManager *myHouseSourceAFNetWorkManager;
}
@property(nonatomic,strong)NSMutableArray *myHouseSource;
@end
