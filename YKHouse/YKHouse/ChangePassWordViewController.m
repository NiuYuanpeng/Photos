//
//  ChangePassWordViewController.m
//  YKHouse
//
//  Created by wjl on 14-7-7.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "ChangePassWordViewController.h"

@interface ChangePassWordViewController ()

@end

@implementation ChangePassWordViewController

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
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topViewBG.png"]];
    self.navigationItem.title=@"修改密码";
    
    telephoneNumberField=[[UITextField alloc] initWithFrame:CGRectMake(20.0, NavigationBarLineY+10.0, self.view.bounds.size.width-40.0, 35.0)];
    telephoneNumberField.placeholder=@"请输入手机号码";
    telephoneNumberField.clearButtonMode=UITextFieldViewModeWhileEditing;
    telephoneNumberField.keyboardType=UIKeyboardTypeNumberPad;
    telephoneNumberField.backgroundColor=[UIColor whiteColor];
    telephoneNumberField.borderStyle=UITextBorderStyleNone;
    [self.view addSubview:telephoneNumberField];
    
    passwordField=[[UITextField alloc] initWithFrame:CGRectMake(telephoneNumberField.frame.origin.x, telephoneNumberField.frame.origin.y+telephoneNumberField.frame.size.height+5.0, self.view.bounds.size.width-40.0, 35.0)];
    passwordField.placeholder=@"请输入您的密码";
    passwordField.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordField.secureTextEntry=YES;
    passwordField.backgroundColor=[UIColor whiteColor];
    passwordField.borderStyle=UITextBorderStyleNone;
    [self.view addSubview:passwordField];
    
    newPassWordField=[[UITextField alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x, passwordField.frame.origin.y+passwordField.frame.size.height+5.0, self.view.bounds.size.width-40.0, 35.0)];
    newPassWordField.placeholder=@"请输入您的新密码";
    newPassWordField.clearButtonMode=UITextFieldViewModeWhileEditing;
    newPassWordField.secureTextEntry=YES;
    newPassWordField.backgroundColor=[UIColor whiteColor];
    newPassWordField.borderStyle=UITextBorderStyleNone;
    [self.view addSubview:newPassWordField];
    
    UIButton *changePassWordBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [changePassWordBtn setBackgroundColor:[UIColor lightGrayColor]];
    changePassWordBtn.frame=CGRectMake(newPassWordField.frame.origin.x, newPassWordField.frame.origin.y+newPassWordField.frame.size.height+30.0, newPassWordField.frame.size.width, newPassWordField.frame.size.height);
    [changePassWordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [changePassWordBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [changePassWordBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    [changePassWordBtn addTarget:self action:@selector(changePassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changePassWordBtn];
    // Do any additional setup after loading the view.
}
-(void)changePassWord{
    if (![self isValidatePhone:telephoneNumberField.text]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"您输入的手机号有误，请重新输入!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [self.view addSubview:alert];
        [alert show];
        return;
    }
    
    if ([passwordField.text isEqualToString:@""]||[newPassWordField.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"密码不能为空，请重新输入!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [self.view addSubview:alert];
        [alert show];
        return;
    }
    changePassword *cpw=[changePassword alloc];
    cpw.changePW_commandcode=127;
    cpw.changePW_username=telephoneNumberField.text;
    cpw.changePW_password=passwordField.text;
    cpw.changePW_newpassword=newPassWordField.text;
    AFNetWorkManager *cpwAFNetWorkManager=[[AFNetWorkManager alloc] init];
    if (cpwAFNetWorkManager.isLoading) {
        //[cpwAFNetWorkManager cancelCurrentRequest];
    }
    cpwAFNetWorkManager.delegate=self;
    [cpwAFNetWorkManager changePassWord:cpw];
}
/*电话号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidatePhone:(NSString *)phoneNum
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|[3-9][0-9][0-9])\\d{7,8}$";
    //NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    if (([regextestmobile evaluateWithObject:phoneNum] == YES)
        || ([regextestcm evaluateWithObject:phoneNum] == YES)
        || ([regextestct evaluateWithObject:phoneNum] == YES)
        || ([regextestcu evaluateWithObject:phoneNum] == YES)
        || ([regextestphs evaluateWithObject:phoneNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma marks afnetworkmanaerdelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    NSLog(@"%@",resultDic);
    if (isSuccess) {
        if (code==127) {
            NSArray *stateList=[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
            if (stateList.count>0) {
                int state=[[[stateList objectAtIndex:0] objectForKey:@"state"] intValue];
                if (state==0) {//成功
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"恭喜您，密码修改成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.delegate=self;
                    [self.view addSubview:alert];
                    [alert show];
                    
                }else if (state==1){//失败
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"修改失败，请重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
