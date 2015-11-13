//
//  ZHouseSearchArealistViewController.m
//  YKHouse
//
//  Created by wjl on 14-6-24.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "ZHouseSearchArealistViewController.h"
#import "ZHouseTableViewCell.h"
#import "ZHouseDetailInfoViewController.h"
#import "MBProgressHUD.h"
@interface ZHouseSearchArealistViewController ()

@end

@implementation ZHouseSearchArealistViewController
@synthesize z_xid=_z_xid;
@synthesize z_searchAreaList=_z_searchAreaList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _zsearchAreaAFNetWorkManager = [[AFNetWorkManager alloc] init];
        _zsearchAreaAFNetWorkManager.delegate = self;
    }
    return self;
}
-(void)addHUDView{
    NSArray *hudArray = [MBProgressHUD allHUDsForView:self.view];
    if (hudArray.count==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在加载...";
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>7.0) {
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }

    searchAreaListTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, NavigationBarLineY, self.view.bounds.size.width, self.view.bounds.size.height-NavigationBarLineY-OtherHeight) style:UITableViewStylePlain];
    searchAreaListTableView.rowHeight=100.0;
    searchAreaListTableView.delegate=self;
    searchAreaListTableView.dataSource=self;
    [self.view addSubview:searchAreaListTableView];
    gmView=[[GetMoreLoadView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50.0)];
    
    _z_searchAreaList=[[NSMutableArray alloc] init];
    zhAreaList=[[zHouseSearchAreaList alloc] init];
    zhAreaList.zhsArea_commandcode=115;
    zhAreaList.zhsArea_page=1;
    zhAreaList.zhsArea_xid=self.z_xid;
    if (self.zsearchAreaAFNetWorkManager.isLoading) {
        //[self.zsearchAreaAFNetWorkManager cancelCurrentRequest];
    }
    [self.zsearchAreaAFNetWorkManager getZHouseSearchAreaList:zhAreaList];
    [self addHUDView];
    // Do any additional setup after loading the view.
}
#pragma mark - AFNetWorkManagerDelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (code==115) {
        if (isSuccess) {
            zh_searchAreaNextPage=[[resultDic objectForKey:@"RESPONSE_NEXTPAGE"] intValue];
            if (zh_searchAreaNextPage==1) {
                zhAreaList.zhsArea_page++;
                searchAreaListTableView.tableFooterView=gmView;
            }else if(zh_searchAreaNextPage==0){
                searchAreaListTableView.tableFooterView=nil;
            }
            [self.z_searchAreaList addObjectsFromArray:[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"]];
            NSLog(@"eshAreaList.eshsArea_page:%d",zhAreaList.zhsArea_page);
            [searchAreaListTableView reloadData];
        }
        NSLog(@"%@",self.z_searchAreaList);
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.z_searchAreaList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"cell";
    ZHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.iconUrl=[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"iconurl"];
    cell.nameString=[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    cell.addressString=[NSString stringWithFormat:@"%@   %@",[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"community"],[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"simpleadd"]];
    cell.hxString=[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"housetype"];
    cell.money=[[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==self.z_searchAreaList.count-1&&zh_searchAreaNextPage&&tableView==searchAreaListTableView&&!self.zsearchAreaAFNetWorkManager.isLoading){//列表是二手房源列表&&显示最后一行&&当前没有请求在进行&&二手房源有下一页
        //        NSLog(@"%d",indexPath.row);
        if (self.zsearchAreaAFNetWorkManager.isLoading) {
            //[self.zsearchAreaAFNetWorkManager cancelCurrentRequest];
        }
        [self.zsearchAreaAFNetWorkManager getZHouseSearchAreaList:zhAreaList];
        [self addHUDView];
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHouseDetailInfoViewController *zHouseDetailInfoVC=[[ZHouseDetailInfoViewController alloc] init];
    zHouseDetailInfoVC.titleNameStr=[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"community"];
    zHouseDetailInfoVC.nid=[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"nid"];
    zHouseDetailInfoVC.zcamera=[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"camera"];
    zHouseDetailInfoVC.zcid=[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"cid"];
    zHouseDetailInfoVC.zhouseType=[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"housetype"];
    zHouseDetailInfoVC.zPrice=[[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"price"] intValue];
    zHouseDetailInfoVC.iconurl=[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"iconurl"];
    zHouseDetailInfoVC.zcommunity=[[self.z_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"title"];
    zHouseDetailInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zHouseDetailInfoVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
