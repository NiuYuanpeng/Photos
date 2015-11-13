//
//  ZHouseSearchArealistViewController.h
//  YKHouse
//
//  Created by wjl on 14-6-24.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorkManager.h"
#import "GetMoreLoadView.h"
@interface ZHouseSearchArealistViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AFNetWorkManagerDelegate>
{
    UITableView *searchAreaListTableView;
    NSMutableArray *_z_searchAreaList;
    NSString *_z_xid;//小区id
    int zh_searchAreaNextPage;//是否有下一页 分页
    zHouseSearchAreaList *zhAreaList;//model
    GetMoreLoadView *gmView;//tableviewFootView
}
@property(nonatomic,strong)AFNetWorkManager *zsearchAreaAFNetWorkManager;
@property(nonatomic,strong)NSString *z_xid;
@property(nonatomic,strong)NSMutableArray *z_searchAreaList;
@end
