//
//  GeRenViewController.h
//  YKHouse
//
//  Created by wjl on 14-5-10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GeRenViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *grTableView;
    NSDictionary *grDic;
    NSMutableArray *grArray;
}

@end
