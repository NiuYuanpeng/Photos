//
//  SelectCommunityViewController.m
//  YKHouse
//
//  Created by wjl on 14-10-15.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "SelectCommunityViewController.h"
#import "MBProgressHUD.h"
@interface SelectCommunityViewController ()

@end

@implementation SelectCommunityViewController
@synthesize selectCommunityArray = _selectCommunityArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectCommunityAFNetWorkManager = [[AFNetWorkManager alloc] init];
        _selectCommunityAFNetWorkManager.delegate = self;
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        cityName = [defaults objectForKey:@"currentCityName"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = cityName;
    
    sBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10.0, 2.0, self.view.bounds.size.width-20.0, 40)];
    sBar.barStyle = UIBarStyleDefault;
    sBar.translucent = YES;
    sBar.delegate = self;
    sBar.showsCancelButton = NO;
    sBar.backgroundImage = [UIImage imageNamed:@"顶部导航底色.png"];
    sBar.placeholder = @"请输入地址或小区名";
    
    _selectCommunityArray=[[NSMutableArray alloc] init];
    
    selectCommunityTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-OtherHeight) style:UITableViewStylePlain];
    selectCommunityTableView.delegate=self;
    selectCommunityTableView.dataSource=self;
    [self.view addSubview:selectCommunityTableView];
    // Do any additional setup after loading the view.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectCommunityArray.count == 0) {
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        if ([userDefault objectForKey:@"selectCommunityHistory"] != nil) {
            NSMutableArray *array = (NSMutableArray *)[userDefault objectForKey:@"selectCommunityHistory"];
            if (array.count > 0) {
               return array.count + 1;
            }
        }
    }
    return self.selectCommunityArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
        if (self.selectCommunityArray.count == 0) {
            cell.textLabel.text = @"历史记录";
        }else{
            cell.textLabel.text = @"搜索结果";
        }
        cell.detailTextLabel.text = @"";
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        if (self.selectCommunityArray.count == 0) {
            NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
            if ([userDefault objectForKey:@"selectCommunityHistory"] != nil) {
                NSMutableArray *array = (NSMutableArray *)[userDefault objectForKey:@"selectCommunityHistory"];
                if (array.count > 0) {
                    cell.textLabel.text = [[array objectAtIndex:indexPath.row - 1] objectForKey:@"community"];
                    cell.detailTextLabel.text = [[array objectAtIndex:indexPath.row - 1] objectForKey:@"address"];
                }
            }
        }else{
            cell.textLabel.text = [[self.selectCommunityArray objectAtIndex:indexPath.row - 1] objectForKey:@"community"];
            cell.detailTextLabel.text = [[self.selectCommunityArray objectAtIndex:indexPath.row - 1] objectForKey:@"address"];
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 30.0;
    }else{
        return 60.0;
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > 0) {
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        if (self.selectCommunityArray.count != 0) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            if ([userDefault objectForKey:@"selectCommunityHistory"] == nil) {
                [array insertObject:[self.selectCommunityArray objectAtIndex:indexPath.row] atIndex:0];
            }else{
                [array addObjectsFromArray:[userDefault objectForKey:@"selectCommunityHistory"]];
                NSLog(@"%lu",(unsigned long)array.count);
                int arrayCount = (int)array.count;
                BOOL isInsert = YES;
                for (int i = 0; i < arrayCount; i++) {
                    NSLog(@"%d",i);
                    if ([[[self.selectCommunityArray objectAtIndex:indexPath.row-1] objectForKey:@"cid"] isEqualToString:[[array objectAtIndex:i] objectForKey:@"cid"]]) {
                        isInsert = NO;
                        break;
                    }
                }
                if (isInsert) {
                    //[array addObject:[self.selectCommunityArray objectAtIndex:indexPath.row-1]];
                    [array insertObject:[self.selectCommunityArray objectAtIndex:indexPath.row-1] atIndex:0];
                }
            }
            
            [userDefault setObject:array forKey:@"selectCommunityHistory"];
            [self.delegate didSelectedCommunity:[self.selectCommunityArray objectAtIndex:indexPath.row - 1]];
        }else{
            NSMutableArray *array1 = (NSMutableArray *)[userDefault objectForKey:@"selectCommunityHistory"];
            [self.delegate didSelectedCommunity:[array1 objectAtIndex:indexPath.row - 1]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.selectCommunityArray.count > 0) {
        return @"搜索结果";
    }
    return @"历史记录";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return sBar;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    selectCommunity *sCommunity=[[selectCommunity alloc] init];
    sCommunity.cityName = cityName;
    sCommunity.searchtext = sBar.text;
    if (self.selectCommunityAFNetWorkManager.isLoading) {
        //[self.searchAFNetWorkManager cancelCurrentRequest];
    }
    [self.selectCommunityAFNetWorkManager selectCommunity:sCommunity];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载...";
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [sBar resignFirstResponder];
}

#pragma mark - AFNetWorkManagerDelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (isSuccess) {
        NSLog(@"%@",resultDic);
        [self.selectCommunityArray removeAllObjects];
        [self.selectCommunityArray addObjectsFromArray:[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"]];
        [selectCommunityTableView reloadData];
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
