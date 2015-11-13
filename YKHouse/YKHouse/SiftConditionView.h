//
//  SiftConditionView.h
//  YKang
//
//  Created by hnsi on 14-4-16.
//  Copyright (c) 2014年 hnsi. All rights reserved.
//
@protocol SiftConditionDelegate <NSObject>
@optional
-(void)siftConditionViewSelectedSegmentIndex:(NSInteger)segmentIndex didSelectedTableVCellString:(NSString *)textForSelectedCell;
-(void)siftConditionViewSelectedSegmentIndex:(NSInteger)segmentIndex didSelectedLeftTableVCellString:(NSString *)textForLeftSelectedCell didSelectedRightTableVCellString:(NSString *)textForRightSelectedCell;
-(void)siftConditionViewSelectedSegmentIndex:(NSInteger)segmentIndex didSelectedLeftTableVCellString:(NSString *)textForLeftSelectedCell didSelectedRightTableVCellString:(NSString *)textForRightSelectedCell title:(NSString *)titleForSelelctedBtn;
-(void)siftConditionViewSelectedSegmentIndex:(NSInteger)segmentIndex didSelectedLeftTableVCellString:(NSString *)textForLeftSelectedCell leftSelectedCellIndex:(NSInteger)leftIndex didSelectedRightTableVCellString:(NSString *)textForRightSelectedCell rightSelectedCellIndex:(NSInteger)rightIndex title:(NSString *)titleForSelelctedBtn;
@end

typedef NS_ENUM(NSInteger, SiftConditionViewLeftTableSeparatorStyle) {
    SiftConditionViewLeftTableSeparatorStyleNone,
    SiftConditionViewLeftTableSeparatorStyleSingleLine,
};

#import <UIKit/UIKit.h>

@interface SiftConditionView : UIView<UITableViewDelegate,UITableViewDataSource,SiftConditionDelegate>
{
    NSMutableArray *_segmentTitleArray;
    UITableView *leftTableV;
    UITableView *rightTableV;
    UIImageView *line;
    NSInteger _firstLeftCurrentIndex;
    NSInteger _firstRightCurrentIndex;
    NSInteger _thirdLeftCurrentIndex;
    NSInteger _thirdRightCurrentIndex;
    NSInteger _secondLeftCurrentIndex;
    NSInteger _secondRightCurrentIndex;
    NSMutableArray *_firstArray;//第一个选项数据源
    NSMutableArray *_secondArray;//第二个选项数据源
    NSMutableArray *_thirdArray;//第三个选项数据源
    int firstTempIndex;
    int secondTempIndex;
    int thirdTempIndex;
    
}
@property(nonatomic,strong)NSMutableArray *segmentTitleArray;
@property(nonatomic,assign)NSInteger selectSegmentValue;
@property(nonatomic,strong)UITableView *leftTableV;
@property(nonatomic,strong)UITableView *rightTableV;
@property(nonatomic,assign)  id <SiftConditionDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *firstArray;
@property(nonatomic,strong)NSMutableArray *secondArray;
@property(nonatomic,strong)NSMutableArray *thirdArray;
@property(assign)NSInteger firstLeftCurrentIndex;
@property(assign)NSInteger firstRightCurrentIndex;
@property(assign)NSInteger thirdLeftCurrentIndex;
@property(assign)NSInteger thirdRightCurrentIndex;
@property(assign)NSInteger secondLeftCurrentIndex;
@property(assign)NSInteger secondRightCurrentIndex;
@property(assign)int firstTempIndex;
@property(assign)int secondTempIndex;
@property(assign)int thirdTempIndex;

@end
