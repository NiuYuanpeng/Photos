//
//  ViewController.m
//  DelegateDemo
//
//  Created by 牛元鹏 on 15/11/18.
//  Copyright © 2015年 牛元鹏. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pressCasting:(UIButton *)sender {
    
    OneViewController *oneVC = [[OneViewController alloc] initWithNibName:@"OneViewController" bundle:nil];
    
    oneVC.delegate = self;
    
    [self presentViewController:oneVC animated:YES completion:nil];
}

#pragma mark - OneVC delegate
- (void)changeValue:(NSString *)value
{
    self.Label.text = value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
