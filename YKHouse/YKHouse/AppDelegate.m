//
//  AppDelegate.m
//  YKHouse
//
//  Created by wjl on 14-5-10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "AppDelegate.h"

#import "ZuHouseViewController.h"
#import "XinHouseViewController.h"
#import "ErShouHouseViewController.h"
#import "GeRenViewController.h"


#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import "WXApi.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "YKSql.h"
@implementation AppDelegate
@synthesize mapManager = _mapManager;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    application.applicationSupportsShakeToEdit = YES;
    
    [self.window makeKeyAndVisible];
    //nid,flag,houseName,houseArea,price,rentStyle,hStyle,sampleAddress,saveDate
    [[YKSql shareMysql] createTable:@"CREATE TABLE IF NOT EXISTS saveHouseInfoTable( nid TEXT,flag INTEGER,houseName TEXT,houseTitle TEXT,houseArea TEXT,price TEXT,rentStyle TEXT,hStyle TEXT,sampleAddress TEXT,iconurl TEXT,saveDate TEXT,primary key(nid,flag))"];
    
    //百度地图
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"93zwSEfG29ZoeuEOYgx3cXoI"  generalDelegate:self];
    if (!ret) {//2.6.0     发布：93zwSEfG29ZoeuEOYgx3cXoI    开发：Vo9GG8hxg886qzSCw0NYstkN  test: ECKWYSGIRAM6mDVd9Z2a2WVv
        NSLog(@"manager start failed!");
    }
    //一键微博分享
    [ShareSDK registerApp:@"26688b3feca4"];
    [ShareSDK connectSinaWeiboWithAppKey:@"2648593421"
                               appSecret:@"b51e060334b858a0b1e4182db6a11dc4"
                             redirectUri:@"http://www.xinyadichan.com/manage/prologin.html"
                             weiboSDKCls:[WeiboApi class]];
    [ShareSDK connectTencentWeiboWithAppKey:@"801525969"
                                  appSecret:@"1a1c4bd96af80e25f4f4bc3a9382cd92"
                                redirectUri:@"http://www.xinyadichan.com/manage/prologin.html"
                                wbApiCls:[WeiboApi class]];
    //添加微信应用
    [ShareSDK connectWeChatWithAppId:@"wx822b7bbce48efe78" wechatCls:[WXApi class]];//此参数为申请的微信AppID
    [ShareSDK connectSMS];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"currentCityName"]==nil) {
        [userDefault setObject:@"昆明" forKey:@"currentCityName"];
        [userDefault setObject:@"25.046818849581" forKey:@"lat"];
        [userDefault setObject:@"102.71197718839" forKey:@"lng"];
    }
    
    
    //自定义tabBar
//    ZuHouseViewController *zuHouseVC=[[ZuHouseViewController alloc] init];
//    zuHouseNav=[[UINavigationController alloc] initWithRootViewController:zuHouseVC];
//    zuHouseNav.tabBarItem.title=@"租房";
//    zuHouseNav.tabBarItem.image=[UIImage imageNamed:@"底部导航-租房未点击.png"];
//    zuHouseNav.tabBarItem.selectedImage=[UIImage imageNamed:@"底部导航-租房点击.png"];
    ZuHouseViewController *zuHouseVC = [[ZuHouseViewController alloc] init];
    zuHouseNav = [[UINavigationController alloc] initWithRootViewController:zuHouseVC];
    zuHouseNav.tabBarItem.title = @"租房";
    zuHouseNav.tabBarItem.image = [UIImage imageNamed:@"底部导航-租房未点击.png"];
    zuHouseNav.tabBarItem.selectedImage = [UIImage imageNamed:@"底部导航-租房点击.png"];
    
    ErShouHouseViewController *erShouHouseVC=[[ErShouHouseViewController alloc] init];
    erShouHouseNav=[[UINavigationController alloc] initWithRootViewController:erShouHouseVC];
    erShouHouseNav.tabBarItem.title=@"二手";
    erShouHouseNav.tabBarItem.image=[UIImage imageNamed:@"底部导航-二手未点击.png"];
    erShouHouseNav.tabBarItem.selectedImage=[UIImage imageNamed:@"底部导航-二手点击.png"];
    
    XinHouseViewController *xinHouseVC=[[XinHouseViewController alloc] init];
    xinHouseNav=[[UINavigationController alloc] initWithRootViewController:xinHouseVC];
    xinHouseNav.tabBarItem.title=@"新房";
    xinHouseNav.tabBarItem.image=[UIImage imageNamed:@"底部导航-新房未点击.png"];
    xinHouseNav.tabBarItem.selectedImage=[UIImage imageNamed:@"底部导航-新房点击.png"];
    
    GeRenViewController *geRenVC=[[GeRenViewController alloc] init];
    geRenNav=[[UINavigationController alloc] initWithRootViewController:geRenVC];
    geRenNav.tabBarItem.title=@"个人";
    geRenNav.tabBarItem.image=[UIImage imageNamed:@"底部导航-个人未点击.png"];
    geRenNav.tabBarItem.selectedImage=[UIImage imageNamed:@"底部导航-个人点击.png"];
    
    NSArray *viewControllers=[NSArray arrayWithObjects:zuHouseNav,erShouHouseNav,geRenNav, nil];
    tabBarController=[[UITabBarController alloc] init];
    tabBarController.viewControllers=viewControllers;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        UserGuideViewController *userGuideViewController = [[UserGuideViewController alloc] init];
        userGuideViewController.delegate=self;
        self.window.rootViewController = userGuideViewController;
    }else{
        ADViewController *adVC = [[ADViewController alloc] init];
        adVC.delegate=self;
        self.window.rootViewController=adVC;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"lid"] isEqualToString:@"成功"]&&[[NSUserDefaults standardUserDefaults] objectForKey:@"currentTelNum"]!=nil&&[[NSUserDefaults standardUserDefaults] objectForKey:@"currentPassWord"]!=nil) {
            
            login *lo=[[login alloc] init];
            lo.login_username = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentTelNum"];
            lo.login_password = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPassWord"];
            AFNetWorkManager *loginAFNetWorkManager=[[AFNetWorkManager alloc] init];
            loginAFNetWorkManager.delegate=self;
            if (loginAFNetWorkManager.isLoading) {
                //[loginAFNetWorkManager cancelCurrentRequest];
            }
            [loginAFNetWorkManager toLogin:lo];
        }
    });
    
    
    //[self getAreaAndDetailArea];
    return YES;
}
-(void)hiddenADVC{
   self.window.rootViewController=tabBarController;
}
-(void)hiddenUserGuideVC{
    ADViewController *adVC = [[ADViewController alloc] init];
    adVC.delegate=self;
    self.window.rootViewController=adVC;
}
-(void)getAreaAndDetailArea{
    cityArea *city=[[cityArea alloc] init];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"currentCityName"] == nil) {
        [userDefault setObject:@"昆明" forKey:@"currentCityName"];
        [userDefault setObject:@"25.046818849581" forKey:@"lat"];
        [userDefault setObject:@"102.71197718839" forKey:@"lng"];
    }
    city.cityName=[userDefault objectForKey:@"currentCityName"];
    AFNetWorkManager *appAFNetWorkManager=[[AFNetWorkManager alloc] init];
    appAFNetWorkManager.delegate=self;
    [appAFNetWorkManager getAreaAndDetailArea:city];
}
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    if (isSuccess) {
        //NSLog(@"resultDic:%@",resultDic);
        if (code == AreaAndStreet_CommandCode) {
            NSArray *listArray=[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
            if (listArray.count>0) {
                NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                [userDefault setObject:listArray forKey:@"area"];
            }
            self.window.rootViewController=tabBarController;
        }else if (code == Login_CommandCode){
            NSArray *stateList=[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
            if (stateList.count > 1) {
                int state=[[[stateList objectAtIndex:0] objectForKey:@"state"] intValue];
                if (state == 0) {//成功
                    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                    [userDefault removeObjectForKey:@"lid"];
                }
            }
        }
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - shareSdk
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}


@end
