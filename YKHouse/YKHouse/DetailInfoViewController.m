//
//  DetailInfoViewController.m
//  YKHouse
//
//  Created by wjl on 14-6-13.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "DetailInfoViewController.h"

@interface DetailInfoViewController ()

@end

@implementation DetailInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=self.titleNameStr;
    UIView *backImgView=[[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-60, 0, 90, 40)];
    backImgView.backgroundColor=[UIColor clearColor];
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame=CGRectMake(10.0, 5.0, 30,30);
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed:@"分享未点击.png"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享点击.png"] forState:UIControlStateHighlighted];
    [backImgView addSubview:shareBtn];
    saveHistoryBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    saveHistoryBtn.frame=CGRectMake(shareBtn.frame.origin.x+20.0+shareBtn.frame.size.width, 5.0, 30, 30);
    [saveHistoryBtn addTarget:self action:@selector(saveHistory:) forControlEvents:UIControlEventTouchUpInside];
    
    [saveHistoryBtn setImage:[UIImage imageNamed:@"收藏未点击.png"] forState:UIControlStateNormal];
    //[saveHistoryBtn setImage:[UIImage imageNamed:@"收藏点击.png"] forState:UIControlStateHighlighted];
    [backImgView addSubview:saveHistoryBtn];
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc] initWithCustomView:backImgView];
    self.navigationItem.rightBarButtonItem=rightBarBtn;
    NSLog(@"%f",[[[UIDevice currentDevice] systemVersion] doubleValue]);
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>7.0) {
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
    // Do any additional setup after loading the view.
}
-(void)share:(UIButton *)sender{
    NSLog(@"DetaiViewController---share");
}
-(void)saveHistory:(UIButton *)sender{
    NSLog(@"DetaiViewController---saveHistory");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
