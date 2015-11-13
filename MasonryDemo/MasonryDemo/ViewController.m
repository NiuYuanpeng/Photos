//
//  ViewController.m
//  MasonryDemo
//
//  Created by 牛元鹏 on 15/11/13.
//  Copyright © 2015年 牛元鹏. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *view1 = [UIView new];
    UIView *view2 = [UIView new];
    UIView *view3 = [UIView new];
    
    view1.backgroundColor = [UIColor redColor];
    view2.backgroundColor = [UIColor yellowColor];
    view3.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    
    _view1 = view1;
    _view2 = view2;
    _view3 = view3;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - layout methods
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // 关掉autoresizing的影响
    _view1.translatesAutoresizingMaskIntoConstraints = NO;
    _view2.translatesAutoresizingMaskIntoConstraints = NO;
    _view3.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 第一种情况
#if 0
    
    //添加view1和view2的水平约束
    NSLayoutConstraint *view1Left = [NSLayoutConstraint constraintWithItem:_view1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    
    NSLayoutConstraint *view1Width = [NSLayoutConstraint constraintWithItem:_view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_view2 attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    NSLayoutConstraint *view1Right = [NSLayoutConstraint constraintWithItem:_view1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_view2 attribute:NSLayoutAttributeLeading multiplier:1 constant:-20];
    
    NSLayoutConstraint *view2Right = [NSLayoutConstraint constraintWithItem:_view2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];
    // view1和view3的垂直约束
    NSLayoutConstraint *view1Top = [NSLayoutConstraint constraintWithItem:_view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:20];
    
   NSLayoutConstraint *view1Height = [NSLayoutConstraint constraintWithItem:_view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_view3 attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    
    NSLayoutConstraint *view1Bottom = [NSLayoutConstraint constraintWithItem:_view1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_view3 attribute:NSLayoutAttributeTop multiplier:1 constant:-20];
    
    NSLayoutConstraint *view3Bottom = [NSLayoutConstraint constraintWithItem:_view3 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20];
    
    // view2的垂直约束
    NSLayoutConstraint *view1CenterY = [NSLayoutConstraint constraintWithItem:_view1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_view2 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

    
    NSLayoutConstraint *view2Height = [NSLayoutConstraint constraintWithItem:_view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_view2 attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    
    // view3的水平约束
    NSLayoutConstraint *view3Left = [NSLayoutConstraint constraintWithItem:_view3 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    
    NSLayoutConstraint *view3Right = [NSLayoutConstraint constraintWithItem:_view3 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];
    
    // 添加约束
    [self.view addConstraints:@[view1Left,view1Width,view1Right,view2Right,view1Top,view1Height,view1Bottom,view3Bottom,view1CenterY,view2Height,view3Left,view3Right]];
#endif
    
// 第二种VFL原生的
#if 0
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self.view,_view1,_view2,_view3);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_view1(_view2)]-20-[_view2]-20-|" options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_view3]-20-|" options:0 metrics:0 views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_view1(_view3)]-20-[_view3]-20-|" options:0 metrics:0 views:views]];
#endif
    
    // 第三种Masonry方法布局
#if 1
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(20);
        make.leading.equalTo(self.view.mas_leading).with.offset(20);
        make.leading.equalTo(_view3);
        make.bottom.equalTo(_view3.mas_top).with.offset(- 20);
        make.trailing.equalTo(_view2.mas_leading).with.offset(- 20);
        make.size.equalTo(_view2);
        make.height.equalTo(_view3);
    }];
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).with.offset(- 20);
        make.centerY.equalTo(_view1);
        make.trailing.equalTo(_view3);
    }];
    
    [_view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(- 20);
    }];
    
#endif
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
