//
//  ZHouseDetailInfoViewController.h
//  YKHouse
//
//  Created by wjl on 14-5-12.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailInfoViewController.h"
#import "ScrollerShowView.h"
#import "ShareSDK/ShareSDK.h"
#import "AFNetWorkManager.h"
@interface ZHouseDetailInfoViewController : DetailInfoViewController<UITableViewDelegate,UITableViewDataSource,ScrollerShowViewDelegate,ISSShareViewDelegate,ISSViewDelegate,AFNetWorkManagerDelegate>
{
    UITableView *zHouseDetailTableView;
    ScrollerShowView *scrollerShowV;
    
    NSMutableArray *_zhDetailArray;
    NSString *_nid;
    NSString *_zcamera;        //是否有录像
    NSString *_zcid;           //小区id
    NSString *_zcommunity;     //所属title
    NSString *_zhouseType;     //房型
    int _zPrice;    //总价
    NSString *_iconurl;
}
@property(nonatomic,strong)AFNetWorkManager *zdAFNetWorkManager;
@property(nonatomic,strong)NSString *nid;
@property(nonatomic,strong)NSMutableArray *zhDetailArray;
@property(nonatomic,strong)NSString *iconurl;
@property(nonatomic,strong)NSString *zcamera;
@property(nonatomic,strong)NSString *zcid;
@property(nonatomic,strong)NSString *zcommunity;
@property(nonatomic,strong)NSString *zhouseType;
@property(assign)int zPrice;
@end
