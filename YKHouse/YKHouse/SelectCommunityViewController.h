//
//  SelectCommunityViewController.h
//  YKHouse
//
//  Created by wjl on 14-10-15.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

@protocol SelectCommunityDelegate <NSObject>
@optional
-(void)didSelectedCommunity:(id)community;

@end

#import <UIKit/UIKit.h>
#import "AFNetWorkManager.h"
@interface SelectCommunityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AFNetWorkManagerDelegate>
{
    UITableView *selectCommunityTableView;
    NSMutableArray *_selectCommunityArray;
    UISearchBar *sBar;
    NSString *cityName;
}
@property(nonatomic,strong)NSMutableArray *selectCommunityArray;
@property(nonatomic,strong)AFNetWorkManager *selectCommunityAFNetWorkManager;
@property (nonatomic, assign)  id <SelectCommunityDelegate> delegate;
@end
