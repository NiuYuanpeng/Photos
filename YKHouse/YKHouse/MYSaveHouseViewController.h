//
//  MYSaveHouseViewController.h
//  YKHouse
//
//  Created by wjl on 14-7-1.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSaveHouseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *saveTableView;
    NSMutableArray *_saveHouseSource;
}
@property(nonatomic,strong)NSMutableArray *saveHouseSource;
@end
