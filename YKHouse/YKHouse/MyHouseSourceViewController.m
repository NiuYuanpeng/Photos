//
//  MyHouseSourceViewController.m
//  YKHouse
//
//  Created by wjl on 14-10-15.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "MyHouseSourceViewController.h"
#import "AddHouseSourceViewController.h"
#import "MyHSDetailInfoViewController.h"
#import "RegisterViewController.h"
#import "MBProgressHUD.h"
@interface MyHouseSourceViewController ()

@end

@implementation MyHouseSourceViewController
@synthesize myHouseSource = _myHouseSource;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *addBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"添加房源" style:UIBarButtonItemStylePlain target:self action:@selector(addHouseSource)];
    self.navigationItem.rightBarButtonItem = addBarBtnItem;
    self.navigationItem.title=@"我的房源";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>7.0) {
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
    myHouseSourceAFNetWorkManager = [[AFNetWorkManager alloc] init];
    myHouseSourceAFNetWorkManager.delegate = self;
    
    _myHouseSource=[[NSMutableArray alloc] init];
    //self.myHouseSource=[[YKSql shareMysql] show:@"select * from saveHouseInfoTable where flag<104 order by saveDate desc"];
    
    myHouseSourceTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-OtherHeight) style:UITableViewStylePlain];
    myHouseSourceTableView.delegate=self;
    myHouseSourceTableView.dataSource=self;
    myHouseSourceTableView.rowHeight=60.0;
    [self.view addSubview:myHouseSourceTableView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    if (myHouseSourceAFNetWorkManager.isLoading) {
        //[myHouseSourceAFNetWorkManager cancelCurrentRequest];
    }
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"lid"]!=nil&&[userDefault objectForKey:@"currentTelNum"]!=nil) {
        [myHouseSourceAFNetWorkManager getMyHouseSourceList:[userDefault objectForKey:@"currentTelNum"]];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在加载...";
    }else{
        [self showAlertView:@"请登录您的账号后,再查看房源信息"];
        return;
    }
}

-(void)showAlertView:(NSString *)alertMessage{
    UIAlertView *communityAlert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:alertMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    communityAlert.delegate = self;
    [self.view addSubview:communityAlert];
    [communityAlert show];
}

-(void)addHouseSource{
    AddHouseSourceViewController *addHSVC = [[AddHouseSourceViewController alloc] init];
    addHSVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:addHSVC animated:YES];
}

#pragma mark - UIAlertDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myHouseSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [[self.myHouseSource objectAtIndex:self.myHouseSource.count - indexPath.row -1] objectForKey:@"community"];
    NSString *rentSell = [[self.myHouseSource objectAtIndex:self.myHouseSource.count - indexPath.row -1] objectForKey:@"rentsell"];
    NSString *houseType = [[self.myHouseSource objectAtIndex:self.myHouseSource.count - indexPath.row -1] objectForKey:@"housetype"];
    NSString *area = [[self.myHouseSource objectAtIndex:self.myHouseSource.count - indexPath.row -1] objectForKey:@"area"];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   %@平米   %@",houseType,area,rentSell];
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyHSDetailInfoViewController *myHSDetailInfoVC = [[MyHSDetailInfoViewController alloc] init];
    myHSDetailInfoVC.myHSDetailInfoDic = (NSMutableDictionary *)[self.myHouseSource objectAtIndex:self.myHouseSource.count - indexPath.row -1];
    [self.navigationController pushViewController:myHSDetailInfoVC animated:YES];
    
}

#pragma mark - AFNetWorkManagerDelegate

-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (isSuccess) {
        NSLog(@"%@",resultDic);
        self.myHouseSource = [[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
        [myHouseSourceTableView reloadData];
    }
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
