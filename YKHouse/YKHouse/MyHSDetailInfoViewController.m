//
//  MyHSDetailInfoViewController.m
//  YKHouse
//
//  Created by wjl on 14/10/23.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "MyHSDetailInfoViewController.h"
#import "EditHouseSourceInfoViewController.h"
#import "RegisterViewController.h"
@interface MyHSDetailInfoViewController ()

@end

@implementation MyHSDetailInfoViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        changeDelegateStateNetWorkManager = [[AFNetWorkManager alloc] init];
        changeDelegateStateNetWorkManager.delegate = self;
        _myHSDetailInfoDic = [[NSDictionary alloc] init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *addBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editHouseSource)];
    self.navigationItem.rightBarButtonItem = addBarBtnItem;
    self.navigationItem.title=@"房源详情";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>7.0) {
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
    
    myHSDetailInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-OtherHeight) style:UITableViewStylePlain];
    myHSDetailInfoTableView.delegate = self;
    myHSDetailInfoTableView.dataSource = self;
    myHSDetailInfoTableView.rowHeight = 40.0;
    myHSDetailInfoTableView.scrollEnabled = NO;
    [self.view addSubview:myHSDetailInfoTableView];
    // Do any additional setup after loading the view.
}

-(void)editHouseSource{
    EditHouseSourceInfoViewController *editHSInfoVC = [[EditHouseSourceInfoViewController alloc] init];
    editHSInfoVC.editHSDic = self.myHSDetailInfoDic;
    [self.navigationController pushViewController:editHSInfoVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 5, self.view.bounds.size.width-110.0, 30.0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 201;
        label.textColor = [UIColor grayColor];
        [cell.contentView addSubview:label];
    }
    UILabel *textField = (UILabel *)[cell.contentView viewWithTag:201];
    
    if (indexPath.row == 2) {
        cell.textLabel.text = @"小区";
        textField.text = [self.myHSDetailInfoDic objectForKey:@"community"];
    }
    else if (indexPath.row == 3){
        cell.textLabel.text = @"户型";
        textField.text = [self.myHSDetailInfoDic objectForKey:@"housetype"];
    }
    else if (indexPath.row == 4){
        cell.textLabel.text = @"面积";
        textField.text = [NSString stringWithFormat:@"%@平米",[self.myHSDetailInfoDic objectForKey:@"area"]];
    }
    else if (indexPath.row == 5){
        cell.textLabel.text = @"期望价格";
        NSString *priceString = [self.myHSDetailInfoDic objectForKey:@"price"];
        if ([[self.myHSDetailInfoDic objectForKey:@"rentsell"] isEqualToString:@"出租"]) {
            textField.text = [priceString stringByAppendingString:@"/月"];
        }else{
            textField.text = [priceString stringByAppendingString:@"万"];
        }
    }

    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 0.0;
    }
    else if (indexPath.row == 1){
       return 20.0;
    }
    else{
        return 40.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40.0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40.0)];
    headerView.tag = 100003;
    UILabel *hSStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0, 80.0, headerView.bounds.size.height)];
    hSStateLabel.backgroundColor = [UIColor clearColor];
    hSStateLabel.text = @"房源状态:";
    [hSStateLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [headerView addSubview:hSStateLabel];
    
    UILabel *delegateStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(hSStateLabel.frame.origin.x + hSStateLabel.bounds.size.width +20.0, 0, headerView.bounds.size.width - 200.0, headerView.bounds.size.height)];
    delegateStateLabel.backgroundColor = [UIColor clearColor];
    delegateStateLabel.tag = 100001;
    delegateStateLabel.textColor = [UIColor redColor];
    [delegateStateLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [headerView addSubview:delegateStateLabel];
    
    
    UISwitch *delegateSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(headerView.bounds.size.width - 80.0, 5.0, 60.0, headerView.bounds.size.height)];
    delegateSwitch.tag = 100002;
    if ([[self.myHSDetailInfoDic objectForKey:@"stats"] intValue] == 0) {
        delegateSwitch.on = YES;
        delegateStateLabel.text = @"委托中...";
    }else if ([[self.myHSDetailInfoDic objectForKey:@"stats"] intValue] == 1) {
        delegateSwitch.on = NO;
        delegateStateLabel.text = @"委托停止";
    }else{
        delegateSwitch.on = NO;
        delegateStateLabel.text = @"已处理";
        delegateSwitch.userInteractionEnabled = NO;
    }
    [delegateSwitch addTarget:self action:@selector(delegateSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:delegateSwitch];
    //headerView.backgroundColor = [UIColor redColor];
    return headerView;
}

-(void)delegateSwitchValueChange:(UISwitch *)sw{
    changeDelegateState *changeDS = [[changeDelegateState alloc] init];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"lid"]!=nil&&[userDefault objectForKey:@"currentTelNum"]!=nil) {
        changeDS.userName =[userDefault objectForKey:@"currentTelNum"];
    }else{
        [self showAlertView:@"请登录您的账号后,再查看房源信息"];
        return;
    }
    
    changeDS.nid = [self.myHSDetailInfoDic objectForKey:@"nid"];
    if (sw.on) {
        changeDS.state = @"0";
    }else{
        changeDS.state = @"1";
    }
    
    if (changeDelegateStateNetWorkManager.isLoading) {
        //[changeDelegateStateNetWorkManager cancelCurrentRequest];
    }
    [changeDelegateStateNetWorkManager changeDelegateState:changeDS];
}

#pragma mark - AFNetWorkManagerDelegate

-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    if (isSuccess) {
        NSLog(@"%@",resultDic);
        NSArray *states = (NSArray *)[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
        int state = [[[states objectAtIndex:0] objectForKey:@"state"] intValue];
        UIView *tableHeaderView = (UIView *)[myHSDetailInfoTableView viewWithTag:100003];
        UILabel *delegateStateLabel = (UILabel *)[tableHeaderView viewWithTag:100001];
        UISwitch *delegateSwitch = (UISwitch *)[tableHeaderView viewWithTag:100002];
        if (state == 0) {
            if (delegateSwitch.on) {
                delegateStateLabel.text = @"委托中...";
            }else {
                delegateStateLabel.text = @"委托停止";
            }
            [self showAlertView:@"恭喜你，委托更改成功"];
        }else{
            [self showAlertView:@"委托更改失败"];
            delegateSwitch.on = !delegateSwitch.on;
        }
    }
}

-(void)showAlertView:(NSString *)alertMessage{
    UIAlertView *communityAlert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:alertMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [self.view addSubview:communityAlert];
    [communityAlert show];
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
