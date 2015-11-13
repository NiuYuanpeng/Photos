//
//  HouseTypePickerView.m
//  YKHouse
//
//  Created by wjl on 14/11/5.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "HouseTypePickerView.h"

@implementation HouseTypePickerView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 9;
    }
    return 10;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [NSString stringWithFormat:@"%d室",row+1];
    }else if (component == 1) {
        return [NSString stringWithFormat:@"%d厅",row];
    }
    return [NSString stringWithFormat:@"%d卫",row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.htDelegate didSelectedHouseTypePickerViewShiRow:[self selectedRowInComponent:0] + 1 TingRow:[self selectedRowInComponent:1] WeiRow:[self selectedRowInComponent:2]];
}


@end
