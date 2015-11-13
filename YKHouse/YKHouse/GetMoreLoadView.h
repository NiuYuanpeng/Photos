//
//  GetMoreLoadView.h
//  YKHouse
//
//  Created by wjl on 14-6-22.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetMoreLoadView : UIView
{
    UILabel *titleLabel;
    UIActivityIndicatorView *activityIndicatorView;
}
@property(nonatomic,copy)NSString *textForTitle;
-(void)stopAnimating;
@end
