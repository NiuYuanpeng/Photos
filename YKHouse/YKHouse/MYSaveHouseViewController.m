//
//  MYSaveHouseViewController.m
//  YKHouse
//
//  Created by wjl on 14-7-1.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "MYSaveHouseViewController.h"
#import "ZHouseDetailInfoViewController.h"
#import "ESHouseDetailViewController.h"
#import "YKSql.h"
#import "ZHouseTableViewCell.h"
@interface MYSaveHouseViewController ()

@end

@implementation MYSaveHouseViewController
@synthesize saveHouseSource=_saveHouseSource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"我的收藏";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>7.0) {
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
    _saveHouseSource=[[NSMutableArray alloc] init];
    self.saveHouseSource=[[YKSql shareMysql] show:@"select * from saveHouseInfoTable where flag<104 order by saveDate desc"];
    
    saveTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-OtherHeight) style:UITableViewStylePlain];
    saveTableView.delegate=self;
    saveTableView.dataSource=self;
    saveTableView.rowHeight=100.0;
    [self.view addSubview:saveTableView];
    // Do any additional setup after loading the view.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.saveHouseSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    ZHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    saveSqlHouseInfo *sSQLHInfo=(saveSqlHouseInfo *)[self.saveHouseSource objectAtIndex:indexPath.row];
    cell.iconUrl=sSQLHInfo.iconurl;
    cell.nameString = sSQLHInfo.houseName;
    cell.addressString = [NSString stringWithFormat:@"%@  %@",sSQLHInfo.houseTitle,sSQLHInfo.sampleAddress];
    if (sSQLHInfo.flag==101) {
        cell.hxString=sSQLHInfo.hStyle;
        cell.moneyString=[NSString stringWithFormat:@"%@/",sSQLHInfo.price];
    }else if (sSQLHInfo.flag==102){
        NSString *hx=[NSString stringWithFormat:@"%@  %@平米",sSQLHInfo.hStyle,sSQLHInfo.houseArea];
        cell.hxString=hx;
        cell.moneyString=[NSString stringWithFormat:@"%@",sSQLHInfo.price];
        cell.month.text=@"万";
    }
    
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    saveSqlHouseInfo *sSQLHInfo=(saveSqlHouseInfo *)[self.saveHouseSource objectAtIndex:indexPath.row];
    if (sSQLHInfo.flag==101) {
        ZHouseDetailInfoViewController *zHouseDetailInfoVC=[[ZHouseDetailInfoViewController alloc] init];
        zHouseDetailInfoVC.titleNameStr=sSQLHInfo.houseTitle;
        zHouseDetailInfoVC.nid=sSQLHInfo.nid;
        zHouseDetailInfoVC.zhouseType=sSQLHInfo.hStyle;
        zHouseDetailInfoVC.zPrice=[sSQLHInfo.price intValue];
        zHouseDetailInfoVC.iconurl=sSQLHInfo.iconurl;
        zHouseDetailInfoVC.zcommunity=sSQLHInfo.houseName;
        zHouseDetailInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:zHouseDetailInfoVC animated:YES];
    }else if (sSQLHInfo.flag==102){
        ESHouseDetailViewController *esHouseDetailInfoVC=[[ESHouseDetailViewController alloc] init];
        esHouseDetailInfoVC.hidesBottomBarWhenPushed = YES;
        esHouseDetailInfoVC.titleNameStr=sSQLHInfo.houseTitle;
        esHouseDetailInfoVC.esnid=sSQLHInfo.nid;
        esHouseDetailInfoVC.eshouseArea=sSQLHInfo.houseArea;
        esHouseDetailInfoVC.escommunity=sSQLHInfo.houseName;
        esHouseDetailInfoVC.eshouseType=sSQLHInfo.hStyle;
        esHouseDetailInfoVC.estotalPrice=sSQLHInfo.price;
        esHouseDetailInfoVC.iconurl=sSQLHInfo.iconurl;
        [self.navigationController pushViewController:esHouseDetailInfoVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    saveSqlHouseInfo *sSQLHInfo=(saveSqlHouseInfo *)[self.saveHouseSource objectAtIndex:indexPath.row];
    if ([[YKSql shareMysql] deleteDataFromSaveHouseInfoWithNid:sSQLHInfo.nid flag:sSQLHInfo.flag]) {
        [self.saveHouseSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
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
