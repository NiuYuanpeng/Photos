//
//  HouseTopView.m
//  YKHouse
//
//  Created by wjl on 14-5-10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "HouseTopView.h"

@implementation HouseTopView
@synthesize selectButtonTitleArray=_selectButtonTitleArray;
@synthesize tagOfDidClickedBtn=_tagOfDidClickedBtn;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
        self.tagOfDidClickedBtn=-1;
        UILabel *downline=[[UILabel alloc] initWithFrame:CGRectMake(0.0, self.bounds.size.height-1, ScreenWidth, 1)];
        downline.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:downline];
        
        float btnWidth=(self.bounds.size.width-14.0)/3;
        for (int i=0; i<3; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(2+(btnWidth+5.0)*i, 5.0, btnWidth, self.bounds.size.height-11.0);
            btn.tag=100+i;
            [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [btn addTarget:self action:@selector(selectBtnDidSelected:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setTitle:[self.selectButtonTitleArray objectAtIndex:i] forState:UIControlStateNormal];
            [self addSubview:btn];
        }
        
        for (int i=0; i<2; i++) {
            UILabel *btnLine=[[UILabel alloc] initWithFrame:CGRectMake((4.0+btnWidth)*(i+1)+1*i, 10.0, 1, self.bounds.size.height-21.0)];
            btnLine.backgroundColor=[UIColor lightGrayColor];
            [self addSubview:btnLine];
        }
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
}

-(void)selectBtnDidSelected:(UIButton *)btn{
    BOOL isHidden=NO;
    if (btn.tag==self.tagOfDidClickedBtn) {
        isHidden=!isHidden;
        self.tagOfDidClickedBtn=-1;
    }else{
        isHidden=NO;
        self.tagOfDidClickedBtn=btn.tag;
    }
    
    [self.delegate houseTopViewSelectBtn:btn indexOfSelectButton:btn.tag-100 siftConditionIsHidden:isHidden];
}

-(void)showButtonsTitle{
    for (int i=0; i<3; i++) {
        UIButton *btn=(UIButton *)[self viewWithTag:100+i];
        [btn setTitle:[self.selectButtonTitleArray objectAtIndex:i] forState:UIControlStateNormal];
    }
}

@end
