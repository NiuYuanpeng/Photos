//
//  EditHouseSourceInfoViewController.m
//  YKHouse
//
//  Created by wjl on 14/10/24.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "EditHouseSourceInfoViewController.h"
#import "RegisterViewController.h"
#import "MBProgressHUD.h"
@interface EditHouseSourceInfoViewController ()

@end

@implementation EditHouseSourceInfoViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        editHSInfoNetWorkManager = [[AFNetWorkManager alloc] init];
        editHSInfoNetWorkManager.delegate = self;
        _editHSDic = [[NSDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"编辑房源";
    UIBarButtonItem *addBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"存储" style:UIBarButtonItemStylePlain target:self action:@selector(saveHouseSource)];
    self.navigationItem.rightBarButtonItem = addBarBtnItem;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>7.0) {
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
    
    editHouseSourceDic = [[NSMutableDictionary alloc] initWithDictionary:self.editHSDic];
    
    NSLog(@"editHouseSourceDic:%@",editHouseSourceDic);
    editHSInfoTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-OtherHeight) style:UITableViewStylePlain];
    editHSInfoTableView.delegate=self;
    editHSInfoTableView.dataSource=self;
    editHSInfoTableView.rowHeight=50.0;
    [self.view addSubview:editHSInfoTableView];
    
    houseTypePickerView = [[HouseTypePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 216)];
    houseTypePickerView.htDelegate = self;
    [self.view addSubview:houseTypePickerView];
    
    NSString *houseTypeString = [editHouseSourceDic objectForKey:@"housetype"];
    NSString *sRow = [houseTypeString substringWithRange:NSMakeRange(0, 1)];
    NSString *tRow = [houseTypeString substringWithRange:NSMakeRange(2, 1)];
    NSString *wRow = [houseTypeString substringWithRange:NSMakeRange(4, 1)];
    [houseTypePickerView selectRow:[sRow integerValue]-1 inComponent:0 animated:NO];
    [houseTypePickerView selectRow:[tRow integerValue] inComponent:1 animated:NO];
    [houseTypePickerView selectRow:[wRow integerValue] inComponent:2 animated:NO];
    // Do any additional setup after loading the view.
}

-(void)saveHouseSource{
    editHouseSource *editHs = [[editHouseSource alloc] init];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"lid"]!=nil&&[userDefault objectForKey:@"currentTelNum"]!=nil) {
        editHs.userName =[userDefault objectForKey:@"currentTelNum"];
    }else{
        [self showAlertView:@"请登录您的账号后,再查看房源信息"];
    }
    
    editHs.nid = [editHouseSourceDic objectForKey:@"nid"];
    
    NSArray *alertMessageArray = [NSArray arrayWithObjects:@"请填写房源户型",@"请填写房源面积",@"请填写您的期望价格", nil];
    UITableViewCell *areaCell = [editHSInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UILabel *houseTypeLabel = (UILabel *)[areaCell viewWithTag:202];
    editHs.houseType = houseTypeLabel.text;
    for (int i = 2; i < 4; i++) {
        UITableViewCell *areaCell = [editHSInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *textField = (UITextField *)[areaCell viewWithTag:201 + i];
        if (textField.text.length == 0) {
            [self showAlertView:[alertMessageArray objectAtIndex:i-1]];
            return;
        }
        else{
            if (i == 2){
                editHs.area = textField.text;
            }
            else if (i == 3){
                editHs.price = textField.text;
            }
        }
    }
    
    editHs.remark = @"";
    if (editHSInfoNetWorkManager.isLoading) {
        //[editHSInfoNetWorkManager cancelCurrentRequest];
    }
    [editHSInfoNetWorkManager editHouseSource:editHs];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在更改...";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
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
                    if ([[editHouseSourceDic objectForKey:@"rentsell"] isEqualToString:@"出租"]) {
                        label.text = @"/月";
                    }else{
                        label.text = @"万";
                    }
                }
                [cell.contentView addSubview:label];
            }
        }
    }
    
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:201 + indexPath.row];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:201 + indexPath.row];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"小区";
        label.text = [editHouseSourceDic objectForKey:@"community"];
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"户型";
        label.text = [editHouseSourceDic objectForKey:@"housetype"];
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"面积";
        textField.text = [editHouseSourceDic objectForKey:@"area"];
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (indexPath.row == 3){
        cell.textLabel.text = @"期望价格";
        textField.text = [editHouseSourceDic objectForKey:@"price"];
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1){
        [self showHouseTypePickerView];
    }
    else if(indexPath.row > 1){
        UITableViewCell *areaCell = [editHSInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        UITextField *textField = (UITextField *)[areaCell viewWithTag:201+indexPath.row];
        [textField becomeFirstResponder];
        [editHSInfoTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    NSLog(@"after:%f",editHSInfoTableView.frame.size.height);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    for (int i = 2; i < 4; i++) {
        UITableViewCell *areaCell = [editHSInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *textField = (UITextField *)[areaCell viewWithTag:201 + i];
        [textField resignFirstResponder];
    }
    [self hiddenHouseTypePickerView];
}

#pragma mark - UItextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self hiddenHouseTypePickerView];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 203) {
        [editHouseSourceDic setObject:textField.text forKey:@"area"];
    }else if (textField.tag == 204){
        [editHouseSourceDic setObject:textField.text forKey:@"price"];
    }
}

#pragma mark - AFNetWorkManagerDelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (isSuccess) {
        NSLog(@"编辑房源：%@",resultDic);
        NSArray *states = (NSArray *)[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
        int state = [[[states objectAtIndex:0] objectForKey:@"state"] intValue];
        if (state == 0) {
            [self showAlertView:@"恭喜你，房源编辑成功"];
        }else{
            [self showAlertView:@"房源编辑失败"];
        }
    }
}
-(void)showAlertView:(NSString *)alertMessage{
    UIAlertView *communityAlert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:alertMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [self.view addSubview:communityAlert];
    communityAlert.delegate = self;
    [communityAlert show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%@",alertView.message);
    if ([alertView.message isEqualToString:@"恭喜你，房源编辑成功"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showHouseTypePickerView{
    for (int i = 2; i < 4; i++) {
        UITableViewCell *areaCell = [editHSInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
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

#pragma mark -HouseTypePickerViewDelegate

-(void)didSelectedHouseTypePickerViewShiRow:(NSInteger)sRow TingRow:(NSInteger)tRow WeiRow:(NSInteger)wRow{
    NSLog(@"%d,%d,%d",sRow,tRow,wRow);
    UITableViewCell *areaCell = [editHSInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UILabel *houseTypeLabel = (UILabel *)[areaCell viewWithTag:202];
    NSString *houseType = [NSString stringWithFormat:@"%d室%d厅%d卫",sRow,tRow,wRow];
    houseTypeLabel.text = houseType;
    
    [editHouseSourceDic setObject:houseType forKey:@"housetype"];
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
