//
//  LoginViewController.h
//  YKHouse
//
//  Created by wjl on 14-5-12.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorkManager.h"
@interface LoginViewController : UIViewController<AFNetWorkManagerDelegate,UIAlertViewDelegate>
{
    UITextField *telephoneNumberField;
    UITextField *passwordField;
}
@end
