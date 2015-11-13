//
//  ZHouseTableViewCell.h
//  YKHouse
//
//  Created by wjl on 14-5-11.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHouseTableViewCell : UITableViewCell
{
    UIImageView *imageView;
    UILabel *nameLabel;
    UILabel *addressLabel;
    UILabel *hxLabel;
    UILabel *moneyLabel;
    UILabel *_month;
}
@property(nonatomic,copy)NSString *iconUrl;
@property(nonatomic,copy)NSString *nameString;
@property(nonatomic,copy)NSString *addressString;
@property(nonatomic,copy)NSString *hxString;
@property(nonatomic,copy)NSString *moneyString;//unused
@property(nonatomic,assign)int money;
@property(nonatomic,strong)UILabel *month;
@end
