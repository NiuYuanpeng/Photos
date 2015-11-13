//
//  CenterViewController.m
//  YKHouse
//
//  Created by wjl on 14-7-7.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "CenterViewController.h"
#import "ChangePassWordViewController.h"
@interface CenterViewController ()

@end

@implementation CenterViewController

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
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>7.0) {
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topViewBG.png"]];
    self.navigationItem.title=@"账号中心";
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    UILabel *usernameLabel=[[UILabel alloc] initWithFrame:CGRectMake(20.0, NavigationBarLineY+10.0, self.view.bounds.size.width-40.0, 35.0)];
    usernameLabel.textAlignment=NSTextAlignmentCenter;
    usernameLabel.text=[userDefault objectForKey:@"currentTelNum"];
    usernameLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:usernameLabel];
    
    UIButton *changePassWordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    changePassWordBtn.frame=CGRectMake(usernameLabel.frame.origin.x, usernameLabel.frame.origin.y+usernameLabel.frame.size.height+15.0, self.view.bounds.size.width-40.0, 35.0);
    [changePassWordBtn setBackgroundColor:[UIColor lightGrayColor]];
    [changePassWordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [changePassWordBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    [changePassWordBtn addTarget:self action:@selector(changePassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changePassWordBtn];
    
    UIButton *exitBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    exitBtn.frame=CGRectMake(changePassWordBtn.frame.origin.x, changePassWordBtn.frame.origin.y+changePassWordBtn.frame.size.height+15.0, self.view.bounds.size.width-40.0, 35.0);
    [exitBtn setBackgroundColor:[UIColor lightGrayColor]];
    [exitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [exitBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];
    // Do any additional setup after loading the view.
}
-(void)loginOut{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    logout *exit=[[logout alloc] init];
    exit.logout_commandcode=128;
    exit.logout_username=[userDefault objectForKey:@"currentTelNum"];
    AFNetWorkManager *exitAFNetWorkManager=[[AFNetWorkManager alloc] init];
    if (exitAFNetWorkManager.isLoading) {
        [exitAFNetWorkManager cancelCurrentRequest];
    }
    exitAFNetWorkManager.delegate=self;
    [exitAFNetWorkManager logout:exit];
}
-(void)changePassWord{
    ChangePassWordViewController *changPWVC=[[ChangePassWordViewController alloc] init];
    [self.navigationController pushViewController:changPWVC animated:YES];
}
#pragma marks afnetworkmanaerdelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    NSLog(@"%@",resultDic);
    if (isSuccess) {
        if (code==128) {
            NSArray *stateList=[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
            if (stateList.count>0) {
                int state=[[[stateList objectAtIndex:0] objectForKey:@"state"] intValue];
                if (state==0) {//成功
                    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                    [userDefault removeObjectForKey:@"lid"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else if (state==1){//失败
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"退出失败，请重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [self.view addSubview:alert];
                    [alert show];
                }
            }
        }
    }
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
