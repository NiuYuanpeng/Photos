//
//  AddHouseSourceViewController.h
//  YKHouse
//
//  Created by wjl on 14-10-15.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorkManager.h"
#import "HouseTypePickerView.h"
@interface AddHouseSourceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AFNetWorkManagerDelegate,HouseTypePicerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    UITableView *addHouseSourceTableView;
    NSMutableArray *_addHouseSourceArray;
    NSDictionary *communityDic;
    UISegmentedControl *rentOrSellSegmentedControl;
    
    HouseTypePickerView *houseTypePickerView;
    AFNetWorkManager *addHouseSourceAFNetWorkManager;
}
@property(nonatomic,strong)NSMutableArray *addHouseSourceArray;
@end
