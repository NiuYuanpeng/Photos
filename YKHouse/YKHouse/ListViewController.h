//
//  ListViewController.h
//  YKHouse
//
//  Created by wjl on 14-6-13.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYSiftConditionView.h"
#import "HouseTopView.h"
#import "AFNetWorkManager.h"
#import "GetMoreLoadView.h"
@interface ListViewController : UIViewController<XYSiftConditionDelegate,HouseTopViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AFNetWorkManagerDelegate>
{
    XYSiftConditionView *siftConditionV;//选择控件体
    NSMutableArray *segmentTitleA;//选择控件头的默认标题
    NSMutableDictionary *LPDic;//选择控件待选标题
    NSMutableDictionary *LPQYDetailDic;//更多待选控件
    HouseTopView *houseTopV;//选择控件头
    UITableView *listTableView;
    UISearchBar *mySearchBar;
    UILabel *secondLine;//uitabbar上方的横线
    UIButton *leftBtn;
    UIButton *rightBtn;
    UIBarButtonItem *leftBarBtnItem;
    UIBarButtonItem *rightBarBtnItem;
    UITableView *searchTableView;
    GetMoreLoadView *gmView;//tableviewFootView
}
-(void)cityBtnClicked:(UIButton *)btn;
-(void)mapBtnClicked:(UIButton *)btn;
@end
