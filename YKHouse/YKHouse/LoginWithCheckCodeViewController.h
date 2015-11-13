//
//  LoginWithCheckCodeViewController.h
//  YKHouse
//
//  Created by wjl on 14-7-7.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorkManager.h"
@interface LoginWithCheckCodeViewController : UIViewController<AFNetWorkManagerDelegate,UIAlertViewDelegate>
{
    UITextField *telephoneNumberField;
    UITextField *checkNumberField;
    UITextField *passwordField;
    int residueSecond;
    UIButton *checkBtn;
    NSTimer *timer;
}
@property(nonatomic,strong)AFNetWorkManager *loginWithCheckCodeAFNetWorkManager;

@end
