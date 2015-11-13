//
//  ZuHouseViewController.m
//  YKHouse
//
//  Created by wjl on 14-5-10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "ZuHouseViewController.h"
#import "CityListViewController.h"
#import "ZHouseTableViewCell.h"
#import "ZHouseDetailInfoViewController.h"
#import "ZHouseSearchArealistViewController.h"
#import "ZHouseMapViewController.h"
#import "MBProgressHUD.h"
@interface ZuHouseViewController ()

@end

@implementation ZuHouseViewController
@synthesize zHouseArray=_zHouseArray;
@synthesize zHouseSearchArray=_zHouseSearchArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _zHouseAFNetWorkManager = [[AFNetWorkManager alloc] init];
        _zHouseAFNetWorkManager.delegate = self;
    }
    return self;
}
-(void)hiddenSiftConditionView{
    siftConditionV.hidden=YES;
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

-(void)mapBtnClicked:(UIButton *)btn{
    [mySearchBar resignFirstResponder];
    ZHouseMapViewController *zhMapVC=[[ZHouseMapViewController alloc] init];
    zhMapVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:zhMapVC animated:YES];
   
}
-(void)cityBtnClicked:(UIButton *)btn{
    if (self.zHouseAFNetWorkManager.isLoading) {
        //[cityAFNetWorkManager cancelCurrentRequest];
    }
    [self.zHouseAFNetWorkManager getCity];
    [self addHUDView];
    [mySearchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *titlePath=[[NSBundle mainBundle] pathForResource:@"SiftZLPTitle" ofType:@"plist"];
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
    
    NSString *segmentLPPath=[[NSBundle mainBundle] pathForResource:@"SiftZLP" ofType:@"plist"];
    NSArray *LPDicTemple=(NSArray *)[[NSArray alloc] initWithContentsOfFile:segmentLPPath];
    [siftConditionV.secondArray addObjectsFromArray:LPDicTemple];
    
    NSString *segmentLPQYPath=[[NSBundle mainBundle] pathForResource:@"SiftZMore" ofType:@"plist"];
    NSArray *LPQYDetailDicTemple=(NSArray *)[[NSArray alloc] initWithContentsOfFile:segmentLPQYPath];
    [siftConditionV.thirdArray addObjectsFromArray:LPQYDetailDicTemple];
    siftConditionV.segmentTitleArray=segmentTitleA;
    [siftConditionV initSegmentTitle:segmentTitleA];
    [self hiddenSiftConditionView];
    siftConditionV.delegate=self;
    
    _zHouseArray=[[NSMutableArray alloc] init];
    _zHouseSearchArray=[[NSMutableArray alloc] init];
    zhList=[[zHouseList alloc] init];
    [self getAreaAndDetailArea];
    // Do any additional setup after loading the view.
}
-(void)getFirstRequest{
    isZHFreshRequest=YES;
    zhList.z_page=1;
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    zhList.z_cityName=[userDefault objectForKey:@"currentCityName"];
    if (self.zHouseAFNetWorkManager.isLoading) {
        //[self.zHouseAFNetWorkManager cancelCurrentRequest];
    }
    [self.zHouseAFNetWorkManager getZHouseList:zhList];
    [self addHUDView];
}

-(void)addHUDView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载...";
}

-(void)changeLeftBtnTitle:(id)title{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:[title object] forKey:@"currentCityName"];
    if (![[userDefault objectForKey:@"currentCityName"] isEqualToString:leftBtn.titleLabel.text]) {
        zhList.z_page=1;
        zhList.z_lat=0.0;
        zhList.z_lng=0.0;
        zhList.z_area=@"";
        zhList.z_businesscCircle=@"";
        zhList.z_price=@"";
        zhList.z_rType=0;
        zhList.z_person=0;
        zhList.z_ztype=0;
        zhList.z_desc=0;
        [self getAreaAndDetailArea];
    }
    [leftBtn setTitle:[userDefault objectForKey:@"currentCityName"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changBtnTitle" object:nil];
}

-(void)getAreaAndDetailArea{
    cityArea *city=[[cityArea alloc] init];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    city.cityName=[userDefault objectForKey:@"currentCityName"];
    if (self.zHouseAFNetWorkManager.isLoading) {
        //[self.zHouseAFNetWorkManager cancelCurrentRequest];
    }
    [self.zHouseAFNetWorkManager getAreaAndDetailArea:city];
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
            NSMutableArray *listArray1 = (NSMutableArray *)[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
            NSMutableArray *listArray = [NSMutableArray arrayWithArray:listArray1];
            
            NSLog(@"%@",listArray);
            NSArray *buXianArray = [NSArray arrayWithObjects: nil];
            NSDictionary *buXianDic = [NSDictionary dictionaryWithObjectsAndKeys:@"不限",@"area",buXianArray,@"listarea", nil];
            [listArray insertObject:buXianDic atIndex:0];
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
            [btn2 setTitle:@"价格" forState:UIControlStateNormal];
            UIButton *btn3=(UIButton *)[houseTopV viewWithTag:100+2];
            [btn3 setTitle:@"更多" forState:UIControlStateNormal];
            //NSLog(@"%d",siftConditionV.rightTableVResource.count);
            [self getFirstRequest];
        }
        else if (code==ZHouseList_CommandCode){//租房列表 108
            NSLog(@"%@",resultDic);
            if (isZHFreshRequest) {
                [self.zHouseArray removeAllObjects];
                isZHFreshRequest=NO;
            }
            zHouseNextPage=[[resultDic objectForKey:@"RESPONSE_NEXTPAGE"] intValue];
            if (zHouseNextPage==1) {
                zhList.z_page++;
                listTableView.tableFooterView=gmView;
            }else if(zHouseNextPage==0){
                listTableView.tableFooterView=nil;
            }
            [self.zHouseArray addObjectsFromArray:[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"]];
            //NSLog(@"eshList.es_page:%d",zhList.z_page);
            [listTableView reloadData];
        }
        else if(code==114){//租房搜索小区 114
            [self.zHouseSearchArray removeAllObjects];
            [self.zHouseSearchArray addObjectsFromArray:[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"]];
            [searchTableView reloadData];
            NSLog(@"%@",resultDic);
        }
    }
    
}

#pragma mark - SiftConditionDelegate
-(void)siftConditionViewSelectedSegmentIndex:(NSInteger)segmentIndex didSelectedLeftTableVCellString:(NSString *)textForLeftSelectedCell leftSelectedCellIndex:(NSInteger)leftIndex didSelectedRightTableVCellString:(NSString *)textForRightSelectedCell rightSelectedCellIndex:(NSInteger)rightIndex title:(NSString *)titleForSelelctedBtn{
    
    switch (segmentIndex) {
        case 0:
            if (![textForLeftSelectedCell isEqualToString:@"不限"]) {
                zhList.z_area=textForLeftSelectedCell;
                zhList.z_businesscCircle=textForRightSelectedCell;
            }else{
                zhList.z_area=@"";
                zhList.z_businesscCircle=@"";
            }
            break;
        case 1:{
            if (leftIndex>0) {//ture 价格 包含
                zhList.z_price=textForLeftSelectedCell;
                if (leftIndex==1) {
                    zhList.z_price=@"0-500";
                }else if (leftIndex==8){
                    zhList.z_price=@"5000";
                }
                //NSLog(@"%@",zhList.z_price);
            }else if (leftIndex==0){
                zhList.z_price=@"";
            }
        }
            break;
        case 2:
        {
            //siftConditionV.thirdLeftCurrentIndex=leftIndex;
            if (leftIndex==0) {//房型
                zhList.z_rType=rightIndex;
                //NSLog(@"%d",eshList.es_rType);
            }else if (leftIndex==1) {//类型  整租、合租
                zhList.z_ztype=rightIndex;
            }else if (leftIndex==2) {//经纪人  个人
                zhList.z_person=rightIndex;
                //NSLog(@"%d",eshList.es_ztype);
            }else if (leftIndex==3) {//排序
                zhList.z_desc=rightIndex;
                //NSLog(@"%d",eshList.es_desc);
            }
        }
            break;
            
        default:
            break;
    }
    isZHFreshRequest=YES;
    zhList.z_page=1;
    if (self.zHouseArray.count>0) {//重新筛选 列表滚动至最顶端
        [listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    zhList.z_cityName=[userDefault objectForKey:@"currentCityName"];
    if (self.zHouseAFNetWorkManager.isLoading) {
        //[self.zHouseAFNetWorkManager cancelCurrentRequest];
    }
    [self.zHouseAFNetWorkManager getZHouseList:zhList];
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
        return [self.zHouseSearchArray count];
    }
    return self.zHouseArray.count;
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
        cell.textLabel.text=[[self.zHouseSearchArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        return cell;
    }
    static NSString *CellIdentifier = @"cell";
    ZHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    //community 小区名称
    cell.iconUrl=[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"iconurl"];
    cell.nameString=[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    cell.addressString=[NSString stringWithFormat:@"%@   %@",[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"community"],[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"simpleadd"]];
    cell.hxString=[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"housetype"];
    cell.money=[[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"price"] integerValue];
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView==searchTableView&&section==0) {
        return @"搜索结果";
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==self.zHouseArray.count-1&&zHouseNextPage&&tableView==listTableView&&!self.zHouseAFNetWorkManager.isLoading){//列表是二手房源列表&&显示最后一行&&当前没有请求在进行&&二手房源有下一页
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        zhList.z_cityName=[userDefault objectForKey:@"currentCityName"];
        if (self.zHouseAFNetWorkManager.isLoading) {
            //[self.zHouseAFNetWorkManager cancelCurrentRequest];
        }
        [self.zHouseAFNetWorkManager getZHouseList:zhList];
        [self addHUDView];
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==searchTableView) {
        ZHouseSearchArealistViewController *zhSearchAreaListVC=[[ZHouseSearchArealistViewController alloc] init];
        zhSearchAreaListVC.title=[[self.zHouseSearchArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        zhSearchAreaListVC.z_xid=[[self.zHouseSearchArray objectAtIndex:indexPath.row] objectForKey:@"xid"];
        zhSearchAreaListVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:zhSearchAreaListVC animated:YES];
        return;
    }
    ZHouseDetailInfoViewController *zHouseDetailInfoVC=[[ZHouseDetailInfoViewController alloc] init];
    zHouseDetailInfoVC.titleNameStr=[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"community"];
    zHouseDetailInfoVC.nid=[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"nid"];
    zHouseDetailInfoVC.zcamera=[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"camera"];
    zHouseDetailInfoVC.zcid=[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"cid"];
    zHouseDetailInfoVC.zhouseType=[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"housetype"];
    zHouseDetailInfoVC.zPrice=[[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"price"] intValue];
    zHouseDetailInfoVC.iconurl=[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"iconurl"];
    zHouseDetailInfoVC.zcommunity=[[self.zHouseArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    zHouseDetailInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zHouseDetailInfoVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    zHouseSearch *zhSearch=[[zHouseSearch alloc] init];
    zhSearch.zhSearch_commandcode=114;
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    zhSearch.zhSearch_cityname=[userDefault objectForKey:@"currentCityName"];
    zhSearch.zhSearch_keyword=mySearchBar.text;
    if (self.zHouseAFNetWorkManager.isLoading) {
        //[self.zHouseAFNetWorkManager cancelCurrentRequest];
    }
    [self.zHouseAFNetWorkManager getZHouseSearchArea:zhSearch];
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
    
    searchTableView.hidden=NO;
    leftBtn.enabled=NO;
    rightBtn.enabled=NO;
    [self hiddenSiftConditionView];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    mySearchBar.text=@"";
    [self.zHouseSearchArray removeAllObjects];
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [mySearchBar resignFirstResponder];
}
@end
