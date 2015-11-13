//
//  ZuHouseViewController.h
//  YKHouse
//
//  Created by wjl on 14-5-10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
@interface ZuHouseViewController : ListViewController
{
    NSMutableArray *_zHouseArray;//租房list数据源
    int zHouseNextPage;//是否有下一页 分页
    zHouseList *zhList;//model
    BOOL isZHFreshRequest;//重新请求
    NSMutableArray *_zHouseSearchArray;//搜索返回数据源
}
@property(nonatomic,strong)AFNetWorkManager *zHouseAFNetWorkManager;
@property(nonatomic,strong)NSMutableArray *zHouseArray;
@property(nonatomic,strong)NSMutableArray *zHouseSearchArray;
@end
