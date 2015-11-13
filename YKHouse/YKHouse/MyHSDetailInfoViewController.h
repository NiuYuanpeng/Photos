//
//  MyHSDetailInfoViewController.h
//  YKHouse
//
//  Created by wjl on 14/10/23.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorkManager.h"
@interface MyHSDetailInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AFNetWorkManagerDelegate>
{
    AFNetWorkManager *changeDelegateStateNetWorkManager;
    UITableView *myHSDetailInfoTableView;
}
@property(nonatomic,strong)NSDictionary *myHSDetailInfoDic;
@end
