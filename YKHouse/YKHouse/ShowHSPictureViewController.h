//
//  ShowHSPictureViewController.h
//  YKHouse
//
//  Created by wjl on 14-7-1.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowHSPictureViewController : UIViewController<UIScrollViewDelegate>
{
    NSMutableArray *_showPics;
    UIScrollView *showScView;
    int _currentPage;
}
@property(assign)int currentPage;
@property(nonatomic,strong)NSMutableArray *showPics;

@end
