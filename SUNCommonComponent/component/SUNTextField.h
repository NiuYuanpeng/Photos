//
//  SUNTextField.h
//  SUNCommonComponent
//
//  Created by 牛元鹏 on 14-11-4.
//  Copyright (c) 2014年 牛元鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUNTextField : UITextField
{
    UILabel *_customerLeftView;
    UIColor *_placeHolderColor;
    CGFloat _cornerRadius;
    UIColor *_backgroundColor;
}

@property (nonatomic, strong) IBOutlet UILabel *customerLeftView;
@property (nonatomic, strong) UIColor *placeHolderColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *backgroundColor;

@end
