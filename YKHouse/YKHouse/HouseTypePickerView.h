//
//  HouseTypePickerView.h
//  YKHouse
//
//  Created by wjl on 14/11/5.
//  Copyright (c) 2014年 wjl. All rights reserved.
//
@protocol HouseTypePicerViewDelegate <NSObject>
@optional
-(void)didSelectedHouseTypePickerViewShiRow:(NSInteger)sRow TingRow:(NSInteger)tRow WeiRow:(NSInteger)wRow;
@end

#import <UIKit/UIKit.h>

@interface HouseTypePickerView : UIPickerView<UIPickerViewDelegate,UIPickerViewDataSource,HouseTypePicerViewDelegate>{
    
}
@property (nonatomic, assign)  id <HouseTypePicerViewDelegate> htDelegate;
@end
