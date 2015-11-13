//
//  SearchViewController.h
//  YKHouse
//
//  Created by wjl on 14-6-16.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorkManager.h"
@interface SearchViewController : UIViewController<UISearchBarDelegate,AFNetWorkManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UISearchBar *sBar;
    UITableView *_searchTableView;
    NSMutableArray *_searchArray;
    int _commandcode;
    NSString *_cityname;//城市
    NSString *_keyword;//地址或者小区名称
    int _currentCommandCode;
}
@property(nonatomic,strong)AFNetWorkManager *searchAFNetWorkManager;
@property(nonatomic,strong)NSMutableArray *searchArray;
@property(nonatomic,strong)NSString *cityname;//城市
@property(nonatomic,strong)NSString *keyword;//地址或者小区名称
@property(nonatomic,strong)UITableView *searchTableView;
@property(assign)int commandcode;
@property(assign)int currentCommandCode;
+(instancetype)shareSearchVC;

@end
