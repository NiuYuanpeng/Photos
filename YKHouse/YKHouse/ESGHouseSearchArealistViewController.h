//
//  ESGHouseSearchArealistViewController.h
//  YKHouse
//
//  Created by wjl on 14-6-23.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorkManager.h"
#import "GetMoreLoadView.h"
@interface ESGHouseSearchArealistViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AFNetWorkManagerDelegate>
{
    UITableView *searchAreaListTableView;
    NSMutableArray *_es_searchAreaList;
    NSString *_es_xid;//小区id
    int esh_searchAreaNextPage;//是否有下一页 分页
    esHouseSearchAreaList *eshAreaList;//model
    GetMoreLoadView *gmView;//tableviewFootView
}
@property(nonatomic,strong)AFNetWorkManager *esSearchAFNetWorkManager;
@property(nonatomic,strong)NSString *es_xid;
@property(nonatomic,strong)NSMutableArray *es_searchAreaList;
@end
