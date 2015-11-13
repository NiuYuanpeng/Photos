//
//  AboutUsViewController.h
//  YKHouse
//
//  Created by wjl on 14-7-13.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorkManager.h"
#import "UIImageView+AFNetworking.h"

@interface AboutUsViewController : UIViewController<AFNetWorkManagerDelegate>
{
    UIImageView *logoImageView;
    UILabel *contentLabel;
}
@end
