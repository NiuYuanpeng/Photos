//
//  SUNTextFieldDemoViewController.h
//  SUNCommonComponent
//
//  Created by 牛元鹏 on 14-11-4.
//  Copyright (c) 2014年 牛元鹏. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SUNTextField.h"

@interface SUNTextFieldDemoViewController : UIViewController
{
    SUNTextField *_textFieldName;
    
}

@property (nonatomic, strong) IBOutlet SUNTextField *textFieldName;

@end
