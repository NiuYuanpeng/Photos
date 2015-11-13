//
//  ChangePassWordViewController.h
//  YKHouse
//
//  Created by wjl on 14-7-7.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorkManager.h"
@interface ChangePassWordViewController : UIViewController<AFNetWorkManagerDelegate>
{
    UITextField *telephoneNumberField;
    UITextField *newPassWordField;
    UITextField *passwordField;
}

@end
