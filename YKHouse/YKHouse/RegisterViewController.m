//
//  RegisterViewController.m
//  YKHouse
//
//  Created by wjl on 14-5-12.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _registerAFNetWorkManager = [[AFNetWorkManager alloc] init];
        _registerAFNetWorkManager.delegate = self;
        residueSecond = 60;
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
    self.navigationItem.title=@"用手机注册";
    UILabel *assertLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0, NavigationBarLineY+10.0, self.view.bounds.size.width, 20.0)];
    assertLabel.backgroundColor=[UIColor clearColor];
    assertLabel.textColor=[UIColor grayColor];
    assertLabel.font=[UIFont systemFontOfSize:14.0];
    assertLabel.textAlignment=NSTextAlignmentCenter;
    assertLabel.text=@"手机号仅用于获取验证码，不会向第三方公开。";
    [self.view addSubview:assertLabel];
    
    UIColor *lightBlue=[UIColor colorWithRed:12.0/255.0 green:157.0/255.0 blue:252.0/255.0 alpha:1];
    
    telephoneNumberField=[[UITextField alloc] initWithFrame:CGRectMake(20.0, assertLabel.frame.origin.y+assertLabel.frame.size.height+20.0, self.view.bounds.size.width-40.0, 35.0)];
    telephoneNumberField.placeholder=@"请输入手机号码";
    telephoneNumberField.clearButtonMode=UITextFieldViewModeWhileEditing;
    telephoneNumberField.keyboardType=UIKeyboardTypeNumberPad;
    telephoneNumberField.backgroundColor=[UIColor whiteColor];
    telephoneNumberField.borderStyle=UITextBorderStyleNone;
    [self.view addSubview:telephoneNumberField];
    
    checkNumberField=[[UITextField alloc] initWithFrame:CGRectMake(telephoneNumberField.frame.origin.x, telephoneNumberField.frame.origin.y+telephoneNumberField.frame.size.height+5.0, self.view.bounds.size.width-140.0, 35.0)];
    checkNumberField.clearButtonMode=UITextFieldViewModeWhileEditing;
    checkNumberField.placeholder=@"请输入验证码";
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
    passwordField.placeholder=@"请输入密码";
    passwordField.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordField.backgroundColor=[UIColor whiteColor];
    passwordField.secureTextEntry=YES;
    passwordField.borderStyle=UITextBorderStyleNone;
    [self.view addSubview:passwordField];
    
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [registerBtn setBackgroundColor:[UIColor lightGrayColor]];
    registerBtn.frame=CGRectMake(passwordField.frame.origin.x, passwordField.frame.origin.y+passwordField.frame.size.height+30.0, passwordField.frame.size.width, passwordField.frame.size.height);
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *goToLoginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    goToLoginBtn.frame=CGRectMake(self.view.bounds.size.width-20.0-120.0, registerBtn.frame.origin.y+registerBtn.frame.size.height+5.0, 120.0, registerBtn.frame.size.height);
    [goToLoginBtn setTitleColor:lightBlue forState:UIControlStateNormal];
    [goToLoginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [goToLoginBtn setTitle:@"用现有手机账号登录" forState:UIControlStateNormal];
    [goToLoginBtn addTarget:self action:@selector(goToLoginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goToLoginBtn];
    
//    checkNumberField.leftViewMode=UITextFieldViewModeAlways;
//    UIImageView *passwordLeftView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"输入密码图标.png"]];
//    checkNumberField.leftView=passwordLeftView;
//    UIImageView *teleNumLeftView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"输入账号图标.png"]];
//    telephoneNumberField.leftViewMode=UITextFieldViewModeAlways;
//    telephoneNumberField.leftView=teleNumLeftView;
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
    cCode.checkCode_code=1;
    if (self.registerAFNetWorkManager.isLoading) {
        //[self.registerAFNetWorkManager cancelCurrentRequest];
    }
    [self.registerAFNetWorkManager getMessageCheckCode:cCode];
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

    NSLog(@"注册");
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
    re.register_username=telephoneNumberField.text;
    re.register_password=passwordField.text;
    re.register_checkCode=checkNumberField.text;
    if ([checkNumberField.text isEqualToString:@""]) {
        
    }
    if (self.registerAFNetWorkManager.isLoading) {
        //[self.registerAFNetWorkManager cancelCurrentRequest];
    }
    [self.registerAFNetWorkManager toRegister:re];
    
}
-(void)goToLoginBtnClicked{
    NSLog(@"用现有手机号码登录");
    LoginViewController *loginVC=[[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
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
        if (code==Register_CommandCode) {
            NSArray *stateList=[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
            if (stateList.count>0) {
                int state=[[[stateList objectAtIndex:0] objectForKey:@"state"] intValue];
                if (state==0) {//成功
                    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                    [userDefault setObject:telephoneNumberField.text forKey:@"currentTelNum"];
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"恭喜您，注册成功!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"现在去登陆", nil];
                    alert.delegate=self;
                    [self.view addSubview:alert];
                    [alert show];
                    
                }else if (state==1){//失败
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"注册失败，请重新注册!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [self.view addSubview:alert];
                    [alert show];
                }else if (state==2){//重复注册
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"手机号码已经存在，请重新注册!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
    if (buttonIndex==1) {
        LoginViewController *loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
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
