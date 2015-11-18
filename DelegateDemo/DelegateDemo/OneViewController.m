//
//  OneViewController.m
//  DelegateDemo
//
//  Created by 牛元鹏 on 15/11/18.
//  Copyright © 2015年 牛元鹏. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)pressChange:(UIButton *)sender {
    
    // 发送代理，并把文本框中的值传过去
    [self.delegate changeValue:self.txtValue.text];
    
    // 退出当前窗口
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
