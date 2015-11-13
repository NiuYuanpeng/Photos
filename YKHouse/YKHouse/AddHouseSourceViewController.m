//
//  AddHouseSourceViewController.m
//  YKHouse
//
//  Created by wjl on 14-10-15.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "AddHouseSourceViewController.h"
#import "SelectCommunityViewController.h"
#import "RegisterViewController.h"
#import "MBProgressHUD.h"
@interface AddHouseSourceViewController ()<SelectCommunityDelegate>
@end

@implementation AddHouseSourceViewController
@synthesize addHouseSourceArray = _addHouseSourceArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"添加房源";
    UIBarButtonItem *addBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"存储" style:UIBarButtonItemStylePlain target:self action:@selector(saveHouseSource)];
    self.navigationItem.rightBarButtonItem = addBarBtnItem;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>7.0) {
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
    
    rentOrSellSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"出租",@"出售", nil]];
    rentOrSellSegmentedControl.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    rentOrSellSegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    rentOrSellSegmentedControl.backgroundColor = [UIColor whiteColor];
    [rentOrSellSegmentedControl addTarget:self action:@selector(selectedSegmentIndexValueChange) forControlEvents:UIControlEventValueChanged];
    rentOrSellSegmentedControl.selectedSegmentIndex = 0;
    
    addHouseSourceAFNetWorkManager = [[AFNetWorkManager alloc] init];
    addHouseSourceAFNetWorkManager.delegate = self;
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
     _addHouseSourceArray = [[NSMutableArray alloc] initWithObjects:@"请选择房源所属小区",@"1室0厅0卫",@"",@"",[userDefault objectForKey:@"currentTelNum"],@"请填写联系人", nil];
    
    addHouseSourceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-OtherHeight) style:UITableViewStylePlain];
    addHouseSourceTableView.delegate = self;
    addHouseSourceTableView.dataSource = self;
    addHouseSourceTableView.rowHeight = 50.0;
    [self.view addSubview:addHouseSourceTableView];
    
    houseTypePickerView = [[HouseTypePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 216)];
    houseTypePickerView.htDelegate = self;
    [self.view addSubview:houseTypePickerView];
    NSLog(@"%@",houseTypePickerView);
    NSLog(@"%@",self.view);
    // Do any additional setup after loading the view.
}

-(void)selectedSegmentIndexValueChange{
    UITableViewCell *areaCell = [addHouseSourceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    UILabel *rentOrSellLabel = (UILabel *)[areaCell viewWithTag:301];
    if (rentOrSellSegmentedControl.selectedSegmentIndex == 0) {
        rentOrSellLabel.text = @"/月";
    }else if (rentOrSellSegmentedControl.selectedSegmentIndex == 1){
        rentOrSellLabel.text = @"万";
    }
}

-(void)saveHouseSource{
    addHouseSource *addHs = [[addHouseSource alloc] init];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"lid"] != nil&&[userDefault objectForKey:@"currentTelNum"] != nil) {
        addHs.userName =[userDefault objectForKey:@"currentTelNum"];
    }else{
        [self showAlertView:@"请登录您的账号后,再查看房源信息"];
        return;
    }
    
    if (rentOrSellSegmentedControl.selectedSegmentIndex == 0) {
        addHs.rentSell = [rentOrSellSegmentedControl titleForSegmentAtIndex:0];
    }
    else{
        addHs.rentSell = [rentOrSellSegmentedControl titleForSegmentAtIndex:1];
    }
    
    if (!communityDic.count>0) {
        [self showAlertView:@"请选择房源所属小区"];
        return;
    }else{
        addHs.cid = [communityDic objectForKey:@"cid"];
    }
    
    UITableViewCell *areaCell = [addHouseSourceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UILabel *houseTypeLabel = (UILabel *)[areaCell viewWithTag:202];
    addHs.houseType = houseTypeLabel.text;
    NSLog(@"houseTypeLabel.text:%@",houseTypeLabel.text);
    NSArray *alertMessageArray = [NSArray arrayWithObjects:@"请填写房源户型",@"请填写房源面积",@"请填写您的期望价格",@"请填写您的联系方式",@"请填写联系人", nil];
    for (int i = 2; i < 6; i++) {
        UITableViewCell *areaCell = [addHouseSourceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *textField = (UITextField *)[areaCell viewWithTag:201+i];
        if (textField.text.length == 0) {
            [self showAlertView:[alertMessageArray objectAtIndex:i-1]];
            return;
        }
        else{
            if (i == 2){
                addHs.area = textField.text;
            }
            else if (i == 3){
                addHs.price = textField.text;
            }
            else if (i == 4){
                addHs.tel = textField.text;
            }
            else if (i == 5){
                addHs.contractName = textField.text;
            }

        }
    }
    
    addHs.remark = @"";
    if (addHouseSourceAFNetWorkManager.isLoading) {
        //[addHouseSourceAFNetWorkManager cancelCurrentRequest];
    }
    [addHouseSourceAFNetWorkManager addHouseSource:addHs];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在存储...";
}

-(void)showHouseTypePickerView{
    for (int i = 2; i < 6; i++) {
        UITableViewCell *areaCell = [addHouseSourceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *textField = (UITextField *)[areaCell viewWithTag:201+i];
        [textField resignFirstResponder];
    }
    
    [UIView beginAnimations:@"showPickerView" context:nil];
    houseTypePickerView.center = CGPointMake(houseTypePickerView.center.x, self.view.frame.size.height - 216/2);
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView commitAnimations];
}

-(void)hiddenHouseTypePickerView{
    [UIView beginAnimations:@"showPickerView" context:nil];
    houseTypePickerView.center = CGPointMake(houseTypePickerView.center.x, self.view.frame.size.height + 216/2);
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView commitAnimations];
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
    NSString *CellIdentifier = [NSString stringWithFormat:@"%dcell",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row < 2) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 5, self.view.bounds.size.width-110.0, 40.0)];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor lightGrayColor];
            label.tag = 201 + indexPath.row;
            [cell.contentView addSubview:label];
        }else{
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100.0, 5, self.view.bounds.size.width-110.0, 40.0)];
            textField.textAlignment = NSTextAlignmentCenter;
            textField.tag = 201+indexPath.row;
            textField.delegate = self;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.textColor = [UIColor grayColor];
            textField.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:textField];
            
            if (indexPath.row < 4) {
                textField.clearButtonMode = UITextFieldViewModeNever;
                textField.frame = CGRectMake(100.0, 5, self.view.bounds.size.width-210.0, 40.0);
                textField.textAlignment = NSTextAlignmentRight;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(textField.frame.origin.x + textField.frame.size.width, textField.frame.origin.y, 60.0, 40.0)];
                label.textAlignment = NSTextAlignmentLeft;
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [UIColor lightGrayColor];
                if (indexPath.row == 2) {
                    label.text = @"平米";
                }else if (indexPath.row == 3){
                    label.tag = 301;
                    if (rentOrSellSegmentedControl.selectedSegmentIndex == 0) {
                        label.text = @"/月";
                    }else{
                        label.text = @"万";
                    }
                }
                [cell.contentView addSubview:label];
                
            }
        }
        
        
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:201 + indexPath.row];
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:201+indexPath.row];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"小区";
        label.text = [self.addHouseSourceArray objectAtIndex:indexPath.row];
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"户型";
        label.text = [self.addHouseSourceArray objectAtIndex:indexPath.row];
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"面积";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (indexPath.row == 3){
        cell.textLabel.text = @"期望价格";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (indexPath.row == 4){
        cell.textLabel.text = @"联系方式";
        textField.text = [self.addHouseSourceArray objectAtIndex:indexPath.row];
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (indexPath.row == 5){
        cell.textLabel.text = @"联系人";
        textField.placeholder = [self.addHouseSourceArray objectAtIndex:indexPath.row];
        textField.keyboardType = UIKeyboardTypeDefault;
    }
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"before:%f",addHouseSourceTableView.frame.size.height);
    if (indexPath.row == 0) {
        SelectCommunityViewController *selectCommunityVC = [[SelectCommunityViewController alloc] init];
        selectCommunityVC.hidesBottomBarWhenPushed=YES;
        selectCommunityVC.delegate = self;
        [self.navigationController pushViewController:selectCommunityVC animated:YES];
    }else if (indexPath.row == 1){
        [self showHouseTypePickerView];
    }
    else{
        UITableViewCell *areaCell = [addHouseSourceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        UITextField *textField = (UITextField *)[areaCell viewWithTag:201+indexPath.row];
        [textField becomeFirstResponder];
        [addHouseSourceTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    NSLog(@"after:%f",addHouseSourceTableView.frame.size.height);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return rentOrSellSegmentedControl;
}
#pragma mark - SelectCommunityDelegate
-(void)didSelectedCommunity:(id)community{
    communityDic = (NSDictionary *)community;
    NSLog(@"%@",[communityDic objectForKey:@"community"]);
    UITableViewCell *cell = [addHouseSourceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *textField = (UITextField *)[cell viewWithTag:201];
    textField.text = [communityDic objectForKey:@"community"];
    [self.addHouseSourceArray replaceObjectAtIndex:0 withObject:[communityDic objectForKey:@"community"]];
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hiddenHouseTypePickerView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    for (int i = 2; i < 6; i++) {
        UITableViewCell *areaCell = [addHouseSourceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *textField = (UITextField *)[areaCell viewWithTag:201+i];
        [textField resignFirstResponder];
    }
}

#pragma mark - UItextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self hiddenHouseTypePickerView];
    [addHouseSourceTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag - 201 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.addHouseSourceArray replaceObjectAtIndex:textField.tag - 201 withObject:textField.text];
    NSLog(@"%@",self.addHouseSourceArray);
}

#pragma mark - AFNetWorkManagerDelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (isSuccess) {
        NSLog(@"%@",resultDic);
        NSArray *states = (NSArray *)[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
        int state = [[[states objectAtIndex:0] objectForKey:@"state"] intValue];
        if (state == 0) {
            [self showAlertView:@"恭喜你，房源添加成功"];
        }else{
            [self showAlertView:@"房源添加失败"];
        }
    }
}

-(void)showAlertView:(NSString *)alertMessage{
    UIAlertView *communityAlert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:alertMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    communityAlert.delegate = self;
    [self.view addSubview:communityAlert];
    [communityAlert show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.message isEqualToString:@"恭喜你，房源添加成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -HouseTypePickerViewDelegate

-(void)didSelectedHouseTypePickerViewShiRow:(NSInteger)sRow TingRow:(NSInteger)tRow WeiRow:(NSInteger)wRow{
    NSLog(@"%d,%d,%d",sRow,tRow,wRow);
    UITableViewCell *areaCell = [addHouseSourceTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UILabel *houseTypeLabel = (UILabel *)[areaCell viewWithTag:202];
    NSString *houseType = [NSString stringWithFormat:@"%d室%d厅%d卫",sRow,tRow,wRow];
    houseTypeLabel.text = houseType;
    [self.addHouseSourceArray replaceObjectAtIndex:1 withObject:houseType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}



//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"键盘高度:%f",kbSize.height);
    //输入框位置动画加载
    addHouseSourceTableView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height - kbSize.height);
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    addHouseSourceTableView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-OtherHeight);
    //do something
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
