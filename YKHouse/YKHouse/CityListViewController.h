//
//  CityListViewController.h
//  YKHouse
//
//  Created by wjl on 14-6-14.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *cityListTableView;
}
@property(nonatomic,strong)NSMutableArray *cityList;
@end
