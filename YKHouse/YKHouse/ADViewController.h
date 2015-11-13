//
//  ADViewController.h
//  YKHouse
//
//  Created by wjl on 14-7-16.
//  Copyright (c) 2014年 wjl. All rights reserved.
//
@protocol ADViewControllerDelegate <NSObject>
@optional
-(void)hiddenADVC;
@end
#import <UIKit/UIKit.h>
#import "AFNetWorkManager.h"
@interface ADViewController : UIViewController<AFNetWorkManagerDelegate>
{
    UIImageView *adImageView;
    UIImageView *guideImageView;
}
@property(assign, nonatomic) id <ADViewControllerDelegate> delegate;
@end
