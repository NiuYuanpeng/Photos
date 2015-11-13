//
//  ESGHouseSearchArealistViewController.m
//  YKHouse
//
//  Created by wjl on 14-6-23.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "ESGHouseSearchArealistViewController.h"
#import "ESHouseTableViewCell.h"
#import "ESHouseDetailViewController.h"
#import "MBProgressHUD.h"
@interface ESGHouseSearchArealistViewController ()

@end

@implementation ESGHouseSearchArealistViewController
@synthesize es_xid=_es_xid;
@synthesize es_searchAreaList=_es_searchAreaList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _esSearchAFNetWorkManager = [[AFNetWorkManager alloc] init];
        _esSearchAFNetWorkManager.delegate = self;
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
    //self.title=self.title;
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
    
    _es_searchAreaList=[[NSMutableArray alloc] init];
    eshAreaList=[[esHouseSearchAreaList alloc] init];
    eshAreaList.eshsArea_page=1;
    eshAreaList.eshsArea_xid=self.es_xid;
    if (self.esSearchAFNetWorkManager.isLoading) {
        //[self.esSearchAFNetWorkManager cancelCurrentRequest];
    }
    [self.esSearchAFNetWorkManager getESHouseSearchAreaList:eshAreaList];
    [self addHUDView];
    // Do any additional setup after loading the view.
}
#pragma mark - AFNetWorkManagerDelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (code==ESHouseSearchAreaList_CommandCode) {
        if (isSuccess) {
            esh_searchAreaNextPage=[[resultDic objectForKey:@"RESPONSE_NEXTPAGE"] intValue];
            if (esh_searchAreaNextPage==1) {
                eshAreaList.eshsArea_page++;
                searchAreaListTableView.tableFooterView=gmView;
            }else if(esh_searchAreaNextPage==0){
                searchAreaListTableView.tableFooterView=nil;
            }
            [self.es_searchAreaList addObjectsFromArray:[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"]];
            NSLog(@"eshAreaList.eshsArea_page:%d",eshAreaList.eshsArea_page);
            [searchAreaListTableView reloadData];
        }
        NSLog(@"%@",self.es_searchAreaList);
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.es_searchAreaList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"cell";
    ESHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ESHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.iconUrl=[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"iconurl"];
    cell.nameString=[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    cell.addressString=[NSString stringWithFormat:@"%@   %@",[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"community"],[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"simpleadd"]];
    NSString *hx=[NSString stringWithFormat:@"%@  %@平米",[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"housetype"],[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"area"]];
    cell.hxString=hx;
    cell.moneyString=[NSString stringWithFormat:@"%@",[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"totalprice"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==self.es_searchAreaList.count-1&&esh_searchAreaNextPage&&tableView==searchAreaListTableView&&!self.esSearchAFNetWorkManager.isLoading){//列表是二手房源列表&&显示最后一行&&当前没有请求在进行&&二手房源有下一页
        //        NSLog(@"%d",indexPath.row);
        if (self.esSearchAFNetWorkManager.isLoading) {
            //[esSearchAFNetWorkManager cancelCurrentRequest];
        }
        [self.esSearchAFNetWorkManager getESHouseSearchAreaList:eshAreaList];
        [self addHUDView];
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESHouseDetailViewController *esHouseDetailInfoVC=[[ESHouseDetailViewController alloc] init];
    esHouseDetailInfoVC.titleNameStr=[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"community"];
    esHouseDetailInfoVC.hidesBottomBarWhenPushed = YES;
    esHouseDetailInfoVC.esnid=[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"nid"];
    esHouseDetailInfoVC.eshouseArea=[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"area"];
    esHouseDetailInfoVC.escamera=[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"camera"];
    esHouseDetailInfoVC.escid=[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"cid"];
    esHouseDetailInfoVC.escommunity=[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"title"];
    esHouseDetailInfoVC.eshouseType=[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"housetype"];
    esHouseDetailInfoVC.estotalPrice=[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"totalprice"];
    esHouseDetailInfoVC.iconurl=[[self.es_searchAreaList objectAtIndex:indexPath.row] objectForKey:@"iconurl"];
    [self.navigationController pushViewController:esHouseDetailInfoVC animated:YES];
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
