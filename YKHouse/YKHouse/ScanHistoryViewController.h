//
//  ScanHistoryViewController.h
//  YKHouse
//
//  Created by wjl on 14-7-5.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *saveTableView;
    NSMutableArray *_historyHouseSource;
}
@property(nonatomic,strong)NSMutableArray *historyHouseSource;
@end
