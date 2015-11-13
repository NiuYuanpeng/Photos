//
//  EditHouseSourceInfoViewController.h
//  YKHouse
//
//  Created by wjl on 14/10/24.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorkManager.h"
#import "HouseTypePickerView.h"
@interface EditHouseSourceInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AFNetWorkManagerDelegate,UITextFieldDelegate,HouseTypePicerViewDelegate,UIAlertViewDelegate>
{
    UITableView *editHSInfoTableView;
    AFNetWorkManager *editHSInfoNetWorkManager;
    
    HouseTypePickerView *houseTypePickerView;
    NSMutableDictionary *editHouseSourceDic;
}
@property(nonatomic,strong)NSDictionary *editHSDic;
@end
