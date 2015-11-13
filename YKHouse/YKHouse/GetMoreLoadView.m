//
//  GetMoreLoadView.m
//  YKHouse
//
//  Created by wjl on 14-6-22.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "GetMoreLoadView.h"

@implementation GetMoreLoadView
@synthesize textForTitle;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        activityIndicatorView=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((ScreenWidth-200.0)/2.0, 5, 40.0, self.bounds.size.height-10.0)];
        [activityIndicatorView startAnimating];
        activityIndicatorView.hidesWhenStopped=YES;
        activityIndicatorView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        [self addSubview:activityIndicatorView];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(activityIndicatorView.frame.origin.x+activityIndicatorView.frame.size.width, 5.0, 160.0, activityIndicatorView.bounds.size.height)];
        titleLabel.text=@"更多房源加载中...";
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.textColor=[UIColor grayColor];
        titleLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:titleLabel];
    }
    return self;
}
-(void)stopAnimating{
    [activityIndicatorView stopAnimating];
}
-(void)setTextForTitle:(NSString *)t{
    if (![t isEqualToString:textForTitle]) {
        textForTitle=[t copy];
        titleLabel.text=textForTitle;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
