//
//  ESHouseDetailViewController.h
//  YKHouse
//
//  Created by wjl on 14-6-14.
//  Copyright (c) 2014年 wjl. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DetailInfoViewController.h"
#import "ScrollerShowView.h"
#import "ShareSDK/ShareSDK.h"
#import "AFNetWorkManager.h"
#import "AFNetWorkManager.h"
@interface ESHouseDetailViewController : DetailInfoViewController<UITableViewDelegate,UITableViewDataSource,ScrollerShowViewDelegate,ISSShareViewDelegate,AFNetWorkManagerDelegate>
{
    UITableView *esHouseDetailTableView;
    ScrollerShowView *scrollerShowV;
    
    NSString *_nid;
    NSString *_houseArea;     //面积
    NSString *_camera;        //是否有录像
    NSString *_cid;           //小区id
    NSString *_community;     //所属小区名称
    NSString *_houseType;     //房型
    NSString *_totalPrice;    //总价
    NSString *_iconurl;
    NSMutableArray *_eshDetailArray;
}
@property(nonatomic,strong)AFNetWorkManager *esdAFNetWorkManager;
@property(nonatomic,strong)NSString *esnid;
@property(nonatomic,strong)NSString *eshouseArea;
@property(nonatomic,strong)NSString *escamera;
@property(nonatomic,strong)NSString *escid;
@property(nonatomic,strong)NSString *escommunity;
@property(nonatomic,strong)NSString *eshouseType;
@property(nonatomic,strong)NSString *estotalPrice;
@property(nonatomic,strong)NSString *iconurl;
@property(nonatomic,strong)NSMutableArray *eshDetailArray;
@end
