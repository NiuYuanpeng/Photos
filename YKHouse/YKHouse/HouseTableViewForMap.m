//
//  HouseTableViewForMap.m
//  YKHouse
//
//  Created by wjl on 14/11/10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "HouseTableViewForMap.h"

@implementation HouseTableViewForMap
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Custom initialization
        UIView *backgroundForTableView=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, 44.0)];
        backgroundForTableView.tag=99999;
        _communityLabel=[[UILabel alloc] initWithFrame:CGRectMake(20.0, 12.0, backgroundForTableView.bounds.size.width-100.0, 20.0)];
        _communityLabel.font=[UIFont systemFontOfSize:18.0];
        [backgroundForTableView addSubview:_communityLabel];
        UIButton *hiddenBGForTableViewButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [hiddenBGForTableViewButton setBackgroundImage:[UIImage imageNamed:@"叉号.png"] forState:UIControlStateNormal];
        //[hiddenBGForTableViewButton addTarget:self action:@selector(hiddenBackGroundForTableView) forControlEvents:UIControlEventTouchUpInside];
        hiddenBGForTableViewButton.frame=CGRectMake(backgroundForTableView.bounds.size.width-40.0, 12.0, 20.0, 20.0);
        [backgroundForTableView addSubview:hiddenBGForTableViewButton];
        UIColor *lineColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"底部导航-蓝色条640px-3px.png"]];
        UILabel *secondLine=[[UILabel alloc] initWithFrame:CGRectMake(0.0, hiddenBGForTableViewButton.frame.origin.y+hiddenBGForTableViewButton.bounds.size.height+10.0, backgroundForTableView.bounds.size.width, 1.0)];
        secondLine.backgroundColor=lineColor;
        [backgroundForTableView addSubview:secondLine];
        backgroundForTableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
        self.tableHeaderView = backgroundForTableView;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
