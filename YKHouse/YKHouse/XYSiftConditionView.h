//
//  XYSiftConditionView.h
//  YKHouse
//
//  Created by wjl on 15/1/19.
//  Copyright (c) 2015年 wjl. All rights reserved.
//
@protocol XYSiftConditionDelegate <NSObject>
@optional

-(void)siftConditionViewSelectedSegmentIndex:(NSInteger)segmentIndex didSelectedLeftTableVCellString:(NSString *)textForLeftSelectedCell leftSelectedCellIndex:(NSInteger)leftIndex didSelectedRightTableVCellString:(NSString *)textForRightSelectedCell rightSelectedCellIndex:(NSInteger)rightIndex title:(NSString *)titleForSelelctedBtn;

@end
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SiftConditionViewLeftTableSeparatorStyle) {
    SiftConditionViewLeftTableSeparatorStyleNone,
    SiftConditionViewLeftTableSeparatorStyleSingleLine,
};
@interface XYSiftConditionView : UIView<UITableViewDelegate,UITableViewDataSource,XYSiftConditionDelegate>{
    
    NSMutableArray *_segmentTitleArray;
    UITableView *leftTableV;
    UITableView *rightTableV;
    UIImageView *line;
    
    NSMutableArray *_firstArray;//第一个选项数据源
    NSMutableArray *_secondArray;//第二个选项数据源
    NSMutableArray *_thirdArray;//第三个选项数据源
   
    //控件显示和选择的条件（左右index的控制）
    NSMutableArray *conditionIndexs;
    
    
}
@property(nonatomic,strong)NSMutableArray *segmentTitleArray;
@property(nonatomic,assign)NSInteger selectSegmentValue;
@property(nonatomic,strong)UITableView *leftTableV;
@property(nonatomic,strong)UITableView *rightTableV;
@property(nonatomic,assign)  id <XYSiftConditionDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *firstArray;
@property(nonatomic,strong)NSMutableArray *secondArray;
@property(nonatomic,strong)NSMutableArray *thirdArray;

-(void)initSegmentTitle:(NSArray *)titles;
@end
