//
//  ErShouHouseViewController.h
//  YKHouse
//
//  Created by wjl on 14-5-10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "AFNetWorkManager.h"
@interface ErShouHouseViewController : ListViewController<AFNetWorkManagerDelegate>
{
    NSMutableArray *_esHouseArray;//二手房list数据源
    int esHouseNextPage;//是否有下一页 分页
    esHouseList *eshList;//二手房model
    BOOL isESHFreshRequest;//重新请求
    NSMutableArray *_esHouseSearchArray;//搜索返回数据源
}
@property(nonatomic,strong)AFNetWorkManager *erHouseAFNetWorkManager;
@property(nonatomic,strong)NSMutableArray *esHouseArray;
@property(nonatomic,strong)NSMutableArray *esHouseSearchArray;
@end
