//
//  OneViewController.h
//  DelegateDemo
//
//  Created by 牛元鹏 on 15/11/18.
//  Copyright © 2015年 牛元鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OneVCDelegate <NSObject>

- (void)changeValue:(NSString *)value;

@end

@interface OneViewController : UIViewController

/**
 此处利用协议来定义代理
 */
@property (nonatomic, unsafe_unretained) id<OneVCDelegate> delegate;

/**
 这个文本框中的值可以自己随意改变。
 当点击“我变变变！”按钮后，它里边的值会回传到调用它的WViewController中
 */
@property (nonatomic, strong) IBOutlet UITextField *txtValue;

- (IBAction)pressChange:(UIButton *)sender;


@end
