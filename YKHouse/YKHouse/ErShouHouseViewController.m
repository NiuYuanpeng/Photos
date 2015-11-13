//
//  ErShouHouseViewController.m
//  YKHouse
//
//  Created by wjl on 14-5-10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "ErShouHouseViewController.h"
#import "ESHouseTableViewCell.h"
#import "ESHouseDetailViewController.h"
#import "GetMoreLoadView.h"
#import "ESGHouseSearchArealistViewController.h"
#import "ESHouseMapViewController.h"
#import "HouseMapViewController.h"

#import "CityListViewController.h"
#import "MBProgressHUD.h"
@interface ErShouHouseViewController ()

@end

@implementation ErShouHouseViewController
@synthesize esHouseArray=_esHouseArray;
@synthesize esHouseSearchArray=_esHouseSearchArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _erHouseAFNetWorkManager = [[AFNetWorkManager alloc] init];
        _erHouseAFNetWorkManager.delegate = self;
    }
    return self;
}
-(void)hiddenSiftConditionView{
    siftConditionV.hidden=YES;
}
-(void)addHUDView{
    NSArray *hudArray = [MBProgressHUD allHUDsForView:self.view];
    if (hudArray.count==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在加载...";
    }
}
-(void)viewWillAppear:(BOOL)animated{
    mySearchBar.hidden=NO;
    [self hiddenSiftConditionView];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if (![[userDefault objectForKey:@"currentCityName"] isEqualToString:leftBtn.titleLabel.text]) {
        [self getFirstRequest];
    }
    [leftBtn setTitle:[userDefault objectForKey:@"currentCityName"] forState:UIControlStateNormal];
    if (!searchTableView.hidden) {
        [self.navigationController.tabBarController.tabBar setHidden:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    mySearchBar.hidden=YES;
}

-(void)cityBtnClicked:(UIButton *)btn{
    if (self.erHouseAFNetWorkManager.isLoading) {
        //[self.erHouseAFNetWorkManager cancelCurrentRequest];
    }
    [self.erHouseAFNetWorkManager getCity];
    [self addHUDView];
    [mySearchBar resignFirstResponder];
}
-(void)mapBtnClicked:(UIButton *)btn{
    NSLog(@"map");
    [mySearchBar resignFirstResponder];
    
    ESHouseMapViewController *eshMapVC=[[ESHouseMapViewController alloc] init];
    eshMapVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:eshMapVC animated:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
    NSString *titlePath=[[NSBundle mainBundle] pathForResource:@"SiftESLPTitle" ofType:@"plist"];
    segmentTitleA=[[NSMutableArray alloc] initWithContentsOfFile:titlePath];
    houseTopV.delegate=self;
    houseTopV.selectButtonTitleArray=segmentTitleA;
    [houseTopV showButtonsTitle];
    
    mySearchBar.delegate=self;
    listTableView.delegate=self;
    listTableView.dataSource=self;
    searchTableView.delegate=self;
    searchTableView.dataSource=self;
    
    NSArray *areaArray=(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"area"];
    [siftConditionV.firstArray addObjectsFromArray:areaArray];
    
    NSString *segmentLPPath=[[NSBundle mainBundle] pathForResource:@"SiftESLP" ofType:@"plist"];
    NSArray *LPDicTemple=(NSArray *)[[NSArray alloc] initWithContentsOfFile:segmentLPPath];
    [siftConditionV.secondArray addObjectsFromArray:LPDicTemple];
    
    NSString *segmentLPQYPath=[[NSBundle mainBundle] pathForResource:@"SiftESMore" ofType:@"plist"];
    NSArray *LPQYDetailDicTemple=(NSArray *)[[NSArray alloc] initWithContentsOfFile:segmentLPQYPath];
    [siftConditionV.thirdArray addObjectsFromArray:LPQYDetailDicTemple];
    
    siftConditionV.segmentTitleArray=segmentTitleA;
    [siftConditionV initSegmentTitle:segmentTitleA];
    [self hiddenSiftConditionView];
    siftConditionV.delegate=self;
    
    _esHouseArray=[[NSMutableArray alloc] init];
    _esHouseSearchArray=[[NSMutableArray alloc] init];
    eshList=[[esHouseList alloc] init];
    [self getFirstRequest];
    // Do any additional setup after loading the view.
}
-(void)getFirstRequest{
    isESHFreshRequest=YES;
    eshList.es_page=1;
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    eshList.es_cityName=[userDefault objectForKey:@"currentCityName"];
    if (self.erHouseAFNetWorkManager.isLoading) {
        //[self.erHouseAFNetWorkManager cancelCurrentRequest];
    }
    [self.erHouseAFNetWorkManager getESHouseList:eshList];
    [self addHUDView];
}
-(void)changeLeftBtnTitle:(id)title{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:[title object] forKey:@"currentCityName"];
    if (![[userDefault objectForKey:@"currentCityName"] isEqualToString:leftBtn.titleLabel.text]) {
        [self getAreaAndDetailArea];
        eshList.es_area=@"";
        eshList.es_businesscCircle=@"";
        eshList.es_page=1;
        eshList.es_lat=0.0;
        eshList.es_lng=0.0;
        eshList.es_price=@"";
        eshList.es_rType=0;
        eshList.es_MJ=@"";
        eshList.es_age=@"";
        eshList.es_ztype=0;
        eshList.es_desc=0;
        [self getFirstRequest];
    }
    [leftBtn setTitle:[userDefault objectForKey:@"currentCityName"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changBtnTitle" object:nil];
}

-(void)getAreaAndDetailArea{
    cityArea *city=[[cityArea alloc] init];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[userDefault objectForKey:@"currentCityName"]);
    city.cityName=[userDefault objectForKey:@"currentCityName"];
    if (self.erHouseAFNetWorkManager.isLoading) {
        //[self.erHouseAFNetWorkManager cancelCurrentRequest];
    }
    [self.erHouseAFNetWorkManager getAreaAndDetailArea:city];
    [self addHUDView];
}
#pragma mark - AFNetWorkManagerDelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    listTableView.tableFooterView=nil;
    if (isSuccess) {
        if (code==CityList_CommandCode) {//获取支持城市列表
            //NSLog(@"%@",resultDic);
            NSMutableArray *array=(NSMutableArray *)[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
            if (array.count>0) {
                CityListViewController *cityListVC=[[CityListViewController alloc] init];
                cityListVC.cityList=[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
                [self presentViewController:cityListVC animated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLeftBtnTitle:) name:@"changBtnTitle" object:nil];
                }];
            }
        }
        else if (code==AreaAndStreet_CommandCode){//获取当前城市的所属区和街道
            NSArray *listArray=[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
            NSLog(@"%@",listArray);
            if (listArray.count>0) {
                NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                [userDefault setObject:listArray forKey:@"area"];
            }
            NSArray *areaArray=(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"area"];
            [siftConditionV.firstArray removeAllObjects];
            [siftConditionV.firstArray addObjectsFromArray:areaArray];

            UIButton *btn1=(UIButton *)[houseTopV viewWithTag:100+0];
            [btn1 setTitle:@"区域" forState:UIControlStateNormal];
            UIButton *btn2=(UIButton *)[houseTopV viewWithTag:100+1];
            [btn2 setTitle:@"售价" forState:UIControlStateNormal];
            UIButton *btn3=(UIButton *)[houseTopV viewWithTag:100+2];
            [btn3 setTitle:@"更多" forState:UIControlStateNormal];
            //NSLog(@"%d",siftConditionV.rightTableVResource.count);
        }
        else if (code==ESHouseList_CommandCode) {
            if (isESHFreshRequest) {
                [self.esHouseArray removeAllObjects];
                isESHFreshRequest=NO;
            }
            esHouseNextPage=[[resultDic objectForKey:@"RESPONSE_NEXTPAGE"] intValue];
            if (esHouseNextPage==1) {
                eshList.es_page++;
                listTableView.tableFooterView=gmView;
            }else if(esHouseNextPage==0){
                listTableView.tableFooterView=nil;
            }
            [self.esHouseArray addObjectsFromArray:[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"]];
            //NSLog(@"102：eshList.es_page:%d",eshList.es_page);
            [listTableView reloadData];
            NSLog(@"%@",resultDic);
        }else if(code==ESHouseSearchArea_CommandCode){
            [self.esHouseSearchArray removeAllObjects];
            [self.esHouseSearchArray addObjectsFromArray:[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"]];
            [searchTableView reloadData];
            //NSLog(@"112：%@",resultDic);
        }
    }
}

#pragma mark - SiftConditionDelegate
-(void)siftConditionViewSelectedSegmentIndex:(NSInteger)segmentIndex didSelectedLeftTableVCellString:(NSString *)textForLeftSelectedCell leftSelectedCellIndex:(NSInteger)leftIndex didSelectedRightTableVCellString:(NSString *)textForRightSelectedCell rightSelectedCellIndex:(NSInteger)rightIndex title:(NSString *)titleForSelelctedBtn{
    switch (segmentIndex) {
        case 0:
            if (![textForLeftSelectedCell isEqualToString:@"不限"]) {
                eshList.es_area=textForLeftSelectedCell;
                eshList.es_businesscCircle=textForRightSelectedCell;
            }else{
                eshList.es_area=@"";
                eshList.es_businesscCircle=@"";
            }
            break;
        case 1:{
            NSRange priceRange=[textForLeftSelectedCell rangeOfString:@"万"];
            if (priceRange.location!=NSNotFound) {//ture 价格 包含
                eshList.es_price=[[textForLeftSelectedCell componentsSeparatedByString:@"万"] objectAtIndex:0];
                if ([eshList.es_price isEqualToString:@"30"]) {
                    eshList.es_price=@"0-30";
                }else if ([eshList.es_price isEqualToString:@"200"]){
                    eshList.es_price=@"200";
                }
            }else if([textForLeftSelectedCell isEqualToString:@"不限"]){
                eshList.es_price=@"";
            }
        }
            break;
        case 2:
        {
            if (leftIndex==0) {//房型
                eshList.es_rType=rightIndex;
            }else if (leftIndex==1) {//面积
                NSRange priceRange=[textForRightSelectedCell rangeOfString:@"平米"];
                if (priceRange.location!=NSNotFound) {//ture 面积 包含
                    eshList.es_MJ=[[textForRightSelectedCell componentsSeparatedByString:@"平米"] objectAtIndex:0];
                    if ([eshList.es_MJ isEqualToString:@"50"]) {
                        eshList.es_MJ=@"0-50";
                    }else if ([eshList.es_MJ isEqualToString:@"300"]){
                        eshList.es_MJ=@"300";
                    }
                }else if([textForRightSelectedCell isEqualToString:@"不限"]){
                    eshList.es_MJ=@"";
                }
            }else if (leftIndex==2) {//房龄
                NSRange priceRange=[textForRightSelectedCell rangeOfString:@"年"];
                if (priceRange.location!=NSNotFound) {//ture 房龄 包含
                    eshList.es_age=[[textForRightSelectedCell componentsSeparatedByString:@"年"] objectAtIndex:0];
                    if ([eshList.es_age isEqualToString:@"2"]) {
                        eshList.es_age=@"0-2";
                    }else if ([eshList.es_age isEqualToString:@"10"]){
                        eshList.es_age=@"10";
                    }
                }else if([textForRightSelectedCell isEqualToString:@"不限"]){
                    eshList.es_age=@"";
                }
            }else if (leftIndex==3) {//类型
                eshList.es_ztype=rightIndex;
            }else if (leftIndex==4) {//排序
                eshList.es_desc=rightIndex;
            }
        }
            break;
            
        default:
            break;
    }
    isESHFreshRequest=YES;
    eshList.es_page=1;
    if (self.esHouseArray.count>0) {
        [listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    eshList.es_cityName=[userDefault objectForKey:@"currentCityName"];
    if (self.erHouseAFNetWorkManager.isLoading) {
        //[self.erHouseAFNetWorkManager cancelCurrentRequest];
    }
    [self.erHouseAFNetWorkManager getESHouseList:eshList];
    [self addHUDView];
    NSString *btnTitle=titleForSelelctedBtn;
    if (rightIndex!=-1) {
        btnTitle=textForRightSelectedCell;
    }else{
        btnTitle=textForLeftSelectedCell;
    }
    UIButton *btn=(UIButton *)[houseTopV viewWithTag:100+segmentIndex];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    houseTopV.tagOfDidClickedBtn=-1;
    [self hiddenSiftConditionView];
}
#pragma mark - HouseTopViewDelegate
-(void)houseTopViewSelectBtn:(UIButton *)btn indexOfSelectButton:(NSInteger)tagOfSelectButton siftConditionIsHidden:(BOOL)isHidden{
    siftConditionV.selectSegmentValue=tagOfSelectButton;
    siftConditionV.hidden=isHidden;
    siftConditionV.rightTableV.hidden=YES;
    [siftConditionV.leftTableV reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==searchTableView) {
        return [self.esHouseSearchArray count];
    }
    return [self.esHouseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==searchTableView) {
        static NSString *CellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        cell.textLabel.text=[[self.esHouseSearchArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        return cell;
    }
    static NSString *CellIdentifier = @"cell";
    ESHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ESHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.iconUrl=[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"iconurl"];
    cell.nameString=[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.addressString=[NSString stringWithFormat:@"%@   %@",[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"community"],[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"simpleadd"]];
    NSString *hx=[NSString stringWithFormat:@"%@  %@平米",[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"housetype"],[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"area"]];
    cell.hxString=hx;
    cell.moneyString=[NSString stringWithFormat:@"%@",[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"totalprice"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.esHouseArray.count-1&&esHouseNextPage&&tableView==listTableView&&!self.erHouseAFNetWorkManager.isLoading){//列表是二手房源列表&&显示最后一行&&当前没有请求在进行&&二手房源有下一页
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        eshList.es_cityName=[userDefault objectForKey:@"currentCityName"];
        if (self.erHouseAFNetWorkManager.isLoading) {
            //[self.erHouseAFNetWorkManager cancelCurrentRequest];
        }
        [self.erHouseAFNetWorkManager getESHouseList:eshList];
        [self addHUDView];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView==searchTableView&&section==0) {
        return @"搜索结果";
    }
    return @"";
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==searchTableView) {
        ESGHouseSearchArealistViewController *eshSearchAreaListVC=[[ESGHouseSearchArealistViewController alloc] init];
        eshSearchAreaListVC.title=[[self.esHouseSearchArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        eshSearchAreaListVC.es_xid=[[self.esHouseSearchArray objectAtIndex:indexPath.row] objectForKey:@"xid"];
        eshSearchAreaListVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:eshSearchAreaListVC animated:YES];
        return;
    }
    ESHouseDetailViewController *esHouseDetailInfoVC=[[ESHouseDetailViewController alloc] init];
    esHouseDetailInfoVC.titleNameStr=[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"community"];
    esHouseDetailInfoVC.hidesBottomBarWhenPushed = YES;
    esHouseDetailInfoVC.esnid=[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"nid"];
    esHouseDetailInfoVC.eshouseArea=[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"area"];
    esHouseDetailInfoVC.escamera=[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"camera"];
    esHouseDetailInfoVC.escid=[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"cid"];
    esHouseDetailInfoVC.escommunity=[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    esHouseDetailInfoVC.eshouseType=[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"housetype"];
    esHouseDetailInfoVC.estotalPrice=[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"totalprice"];
    esHouseDetailInfoVC.iconurl=[[self.esHouseArray objectAtIndex:indexPath.row] objectForKey:@"iconurl"];
    [self.navigationController pushViewController:esHouseDetailInfoVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchBarSearchButtonClicked");
    [searchBar resignFirstResponder];
    esHouseSearch *eshSearch=[[esHouseSearch alloc] init];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    eshSearch.eshSearch_cityname=[userDefault objectForKey:@"currentCityName"];
    eshSearch.eshSearch_keyword=mySearchBar.text;
    if (self.erHouseAFNetWorkManager.isLoading) {
        //[self.erHouseAFNetWorkManager cancelCurrentRequest];
    }
    [self.erHouseAFNetWorkManager getESHouseSearchArea:eshSearch];
    [self addHUDView];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    //隐藏横线和uitabbar
    secondLine.hidden=YES;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.rightBarButtonItem=nil;
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    
    mySearchBar.showsCancelButton=YES;//必须放在遍历UISearchBar的subviews之前
    CGFloat searBarX,searchBarWidth;
    if ([UIDevice currentDevice].systemVersion.doubleValue<7.0) {
        for (UIView *searchbuttons in mySearchBar.subviews)
        {
            if ([searchbuttons isKindOfClass:[UIButton class]])
            {
                UIButton *cancelButton = (UIButton*)searchbuttons;
                cancelButton.enabled = YES;
                [cancelButton setBackgroundImage:[UIImage imageNamed:@"顶部导航底色.png"] forState:UIControlStateNormal];//背景
                [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
                [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cancelButton setTitle:@"取消"  forState:UIControlStateNormal];//文字
                break;
            }
        }
        searBarX=12.0;
        searchBarWidth=self.view.bounds.size.width-24.0;
    }else{
        UIView *subView=[mySearchBar.subviews objectAtIndex:0];
        for (UIView *searchbuttons in subView.subviews)
        {
            if ([searchbuttons isKindOfClass:[UIButton class]])
            {
                UIButton *cancelButton = (UIButton*)searchbuttons;
                cancelButton.enabled = YES;
                [cancelButton setBackgroundImage:[UIImage imageNamed:@"顶部导航底色.png"] forState:UIControlStateNormal];//背景
                [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
                [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cancelButton setTitle:@"取消"  forState:UIControlStateNormal];//文字
                break;
            }
        }
        searBarX=19.0;
        searchBarWidth=self.view.bounds.size.width-40.0;
    }
    mySearchBar.frame=CGRectMake(19.0, 2.0, self.view.bounds.size.width-40.0, 40.0);
    mySearchBar.frame=CGRectMake(searBarX, 2.0, searchBarWidth, 40.0);
    [self hiddenSiftConditionView];
    searchTableView.hidden=NO;
    leftBtn.enabled=NO;
    rightBtn.enabled=NO;
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    mySearchBar.text=@"";
    [self.esHouseSearchArray removeAllObjects];
    [searchTableView reloadData];
    mySearchBar.showsCancelButton=NO;
    mySearchBar.frame=CGRectMake(70.0, 2.0, self.view.bounds.size.width-140.0, 40);
    [mySearchBar resignFirstResponder];
    searchTableView.hidden=YES;
    leftBtn.enabled=YES;
    rightBtn.enabled=YES;
    //显示uitabbar和横线
    secondLine.hidden=NO;
    self.navigationItem.leftBarButtonItem=leftBarBtnItem;
    self.navigationItem.rightBarButtonItem=rightBarBtnItem;
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [mySearchBar resignFirstResponder];
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
