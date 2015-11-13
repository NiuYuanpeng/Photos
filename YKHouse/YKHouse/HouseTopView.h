//
//  HouseTopView.h
//  YKHouse
//
//  Created by wjl on 14-5-10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//
@protocol HouseTopViewDelegate <NSObject>
@optional
-(void)houseTopViewSelectBtn:(UIButton *)btn indexOfSelectButton:(NSInteger)tagOfSelectButton siftConditionIsHidden:(BOOL)isHidden;

@end
#import <UIKit/UIKit.h>

@interface HouseTopView : UIView
{
    NSArray *_selectButtonTitleArray;
    NSInteger _tagOfDidClickedBtn;
}
@property(nonatomic,assign)NSInteger tagOfDidClickedBtn;
@property(nonatomic,strong)NSArray *selectButtonTitleArray;
@property (nonatomic, assign)  id <HouseTopViewDelegate> delegate;

-(void)showButtonsTitle;
@end
