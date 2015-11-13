//
//  DetailInfoViewController.h
//  YKHouse
//
//  Created by wjl on 14-6-13.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DetailInfoViewController : UIViewController
{
    UIButton *saveHistoryBtn;
}
@property(nonatomic,strong)NSString *titleNameStr;

-(void)share:(UIButton *)sender;
-(void)saveHistory:(UIButton *)sender;
@end
