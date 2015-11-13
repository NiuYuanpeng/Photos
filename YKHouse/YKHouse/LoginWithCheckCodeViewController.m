//
//  LoginWithCheckCodeViewController.m
//  YKHouse
//
//  Created by wjl on 14-7-7.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "LoginWithCheckCodeViewController.h"

@interface LoginWithCheckCodeViewController ()

@end

@implementation LoginWithCheckCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _loginWithCheckCodeAFNetWorkManager = [[AFNetWorkManager alloc] init];
        _loginWithCheckCodeAFNetWorkManager.delegate = self;
        residueSecond = 60;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topViewBG.png"]];
    self.navigationItem.title=@"登录";
    
    UIColor *lightBlue=[UIColor colorWithRed:12.0/255.0 green:157.0/255.0 blue:252.0/255.0 alpha:1];
    
    telephoneNumberField=[[UITextField alloc] initWithFrame:CGRectMake(20.0, NavigationBarLineY+10.0, self.view.bounds.size.width-40.0, 35.0)];
    telephoneNumberField.placeholder=@"请输入手机号码";
    telephoneNumberField.clearButtonMode=UITextFieldViewModeWhileEditing;
    telephoneNumberField.keyboardType=UIKeyboardTypeNumberPad;
    telephoneNumberField.backgroundColor=[UIColor whiteColor];
    telephoneNumberField.borderStyle=UITextBorderStyleNone;
    [self.view addSubview:telephoneNumberField];
    
    checkNumberField=[[UITextField alloc] initWithFrame:CGRectMake(telephoneNumberField.frame.origin.x, telephoneNumberField.frame.origin.y+telephoneNumberField.frame.size.height+5.0, self.view.bounds.size.width-140.0, 35.0)];
    checkNumberField.placeholder=@"请输入验证码";
    checkNumberField.clearButtonMode=UITextFieldViewModeWhileEditing;
    checkNumberField.backgroundColor=[UIColor whiteColor];
    checkNumberField.keyboardType = UIKeyboardTypeNumberPad;
    checkNumberField.borderStyle=UITextBorderStyleNone;
    [self.view addSubview:checkNumberField];
    
    checkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn setBackgroundColor:lightBlue];
    checkBtn.frame=CGRectMake(checkNumberField.frame.origin.x+checkNumberField.frame.size.width, checkNumberField.frame.origin.y, 100.0, 35.0);
    [checkBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBtn];
    
    passwordField=[[UITextField alloc] initWithFrame:CGRectMake(checkNumberField.frame.origin.x, checkNumberField.frame.origin.y+checkNumberField.frame.size.height+5.0, self.view.bounds.size.width-40.0, 35.0)];
    passwordField.placeholder=@"请输入您的新密码";
    passwordField.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordField.secureTextEntry=YES;
    passwordField.backgroundColor=[UIColor whiteColor];
    passwordField.borderStyle=UITextBorderStyleNone;
    [self.view addSubview:passwordField];
    
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [registerBtn setBackgroundColor:[UIColor lightGrayColor]];
    registerBtn.frame=CGRectMake(passwordField.frame.origin.x, passwordField.frame.origin.y+passwordField.frame.size.height+30.0, passwordField.frame.size.width, passwordField.frame.size.height);
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [registerBtn setTitle:@"登录" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    // Do any additional setup after loading the view.
}

-(void)telNumberTextChange{
    checkBtn.userInteractionEnabled = NO;
    [checkBtn setTitle:[NSString stringWithFormat:@"%d秒后重试",residueSecond] forState:UIControlStateNormal];
    residueSecond--;
    if (residueSecond == 0) {
        [timer invalidate];
        checkBtn.userInteractionEnabled = YES;
        [checkBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        residueSecond = 60;
    }
}

-(void)checkBtnClicked{
    NSLog(@"获取验证码");
    if (![self isValidatePhone:telephoneNumberField.text]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"您输入的手机号有误，请重新输入!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [self.view addSubview:alert];
        [alert show];
        return;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(telNumberTextChange) userInfo:nil repeats:YES];
    checkCode *cCode=[[checkCode alloc] init];
    cCode.checkCode_username=telephoneNumberField.text;
    cCode.checkCode_commandcode=125;
    cCode.checkCode_code=2;
    if (self.loginWithCheckCodeAFNetWorkManager.isLoading) {
        //[self.loginWithCheckCodeAFNetWorkManager cancelCurrentRequest];
    }
    [self.loginWithCheckCodeAFNetWorkManager getMessageCheckCode:cCode];
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
-(void)registerBtnClicked{
    
    NSLog(@"登录");
    if (![self isValidatePhone:telephoneNumberField.text]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"您输入的手机号有误，请重新输入!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [self.view addSubview:alert];
        [alert show];
        return;
    }
    
    if ([passwordField.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"密码不能为空，请重新输入!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [self.view addSubview:alert];
        [alert show];
        return;
    }
    registe *re=[[registe alloc] init];
    re.register_commandcode=126;
    re.register_username=telephoneNumberField.text;
    re.register_password=passwordField.text;
    re.register_checkCode=checkNumberField.text;
    if ([checkNumberField.text isEqualToString:@""]) {
        
    }
    if (self.loginWithCheckCodeAFNetWorkManager.isLoading) {
        //[self.loginWithCheckCodeAFNetWorkManager cancelCurrentRequest];
    }
    [self.loginWithCheckCodeAFNetWorkManager loginWithCheckCode:re];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField *tf=(UITextField *)obj;
            [tf resignFirstResponder];
        }
    }
}
#pragma mark - AFNetWorkManageDelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    NSLog(@"%@",resultDic);
    if (isSuccess) {
        if (code==126) {
            NSArray *stateList=[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
            if (stateList.count>0) {
                int state=[[[stateList objectAtIndex:0] objectForKey:@"state"] intValue];
                if (state==0) {//成功
                    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                    [userDefault setObject:telephoneNumberField.text forKey:@"currentTelNum"];
                    [userDefault setObject:passwordField.text forKey:@"currentPassWord"];
                    [userDefault setObject:@"成功" forKey:@"lid"];
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"恭喜您，登录成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.delegate=self;
                    alert.tag=126;
                    [self.view addSubview:alert];
                    [alert show];
                    
                }else if (state==1){//失败
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"登录失败，请重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==126) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
