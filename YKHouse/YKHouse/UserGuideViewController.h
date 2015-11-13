//
//  UserGuideViewController.h
//  YKHouse
//
//  Created by wjl on 14-7-16.
//  Copyright (c) 2014年 wjl. All rights reserved.
//
@protocol UserGuideViewControllerDelegate <NSObject>
@optional
-(void)hiddenUserGuideVC;
@end
#import <UIKit/UIKit.h>

@interface UserGuideViewController : UIViewController<UIScrollViewDelegate>
{
    NSMutableArray *_showPics;
    UIScrollView *showScView;
    int _currentPage;
}
@property(nonatomic, assign) id <UserGuideViewControllerDelegate> delegate;
@end
