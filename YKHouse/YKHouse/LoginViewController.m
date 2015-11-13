//
//  LoginViewController.m
//  YKHouse
//
//  Created by wjl on 14-5-12.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginWithCheckCodeViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationItem.hidesBackButton=YES;
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
    self.navigationItem.title=@"登录";
    UIColor *lightBlue=[UIColor colorWithRed:12.0/255.0 green:157.0/255.0 blue:252.0/255.0 alpha:1];
    
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
    
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setBackgroundColor:[UIColor lightGrayColor]];
    loginBtn.frame=CGRectMake(passwordField.frame.origin.x, passwordField.frame.origin.y+passwordField.frame.size.height+30.0, passwordField.frame.size.width, passwordField.frame.size.height);
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *goToRegisterBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    goToRegisterBtn.frame=CGRectMake(loginBtn.frame.origin.x, loginBtn.frame.origin.y+loginBtn.frame.size.height+5.0, 60.0, loginBtn.frame.size.height);
    goToRegisterBtn.enabled=NO;
    [goToRegisterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [goToRegisterBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [goToRegisterBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    //[goToRegisterBtn addTarget:self action:@selector(goToRegisterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goToRegisterBtn];
    
    UIButton *LoginErrorBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    LoginErrorBtn.frame=CGRectMake(goToRegisterBtn.frame.origin.x+goToRegisterBtn.frame.size.width, loginBtn.frame.origin.y+loginBtn.frame.size.height+5.0, 120.0, loginBtn.frame.size.height);
    [LoginErrorBtn setTitleColor:lightBlue forState:UIControlStateNormal];
    [LoginErrorBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [LoginErrorBtn setTitle:@"通过短信验证码登录" forState:UIControlStateNormal];
    [LoginErrorBtn addTarget:self action:@selector(LoginErrorBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LoginErrorBtn];
    // Do any additional setup after loading the view.
}
-(void)goToRegisterBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
-(void)loginBtnClicked{
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
    login *lo=[[login alloc] init];
    lo.login_username=telephoneNumberField.text;
    lo.login_password=passwordField.text;
    AFNetWorkManager *loginAFNetWorkManager=[[AFNetWorkManager alloc] init];
    loginAFNetWorkManager.delegate=self;
    if (loginAFNetWorkManager.isLoading) {
        //[loginAFNetWorkManager cancelCurrentRequest];
    }
    [loginAFNetWorkManager toLogin:lo];
}
-(void)LoginErrorBtnClicked{
    NSLog(@"用现有手机号码登录");
    LoginWithCheckCodeViewController *loginWithCheckCodeVC=[[LoginWithCheckCodeViewController alloc] init];
    [self.navigationController pushViewController:loginWithCheckCodeVC animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField *tf=(UITextField *)obj;
            [tf resignFirstResponder];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AFNetWorkManage
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    NSLog(@"%@",resultDic);
    if (isSuccess) {
        if (code==Login_CommandCode) {
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
                    alert.tag=111;
                    [self.view addSubview:alert];
                    [alert show];
                    
                }else if (state==1){//失败
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"登录失败，请重新登录!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [self.view addSubview:alert];
                    [alert show];
                }
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==111) {
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
