//
//  HouseMapViewController.m
//  YKHouse
//
//  Created by wjl on 14/11/10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "HouseMapViewController.h"
#import "SearchViewController.h"
#import "ESHouseTableViewCell.h"
@interface HouseMapViewController ()

@end

@implementation HouseMapViewController

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    for (id object in [_mapView subviews]) {
        if ([object isKindOfClass:[HouseTableViewForMap class]]) {
            HouseTableViewForMap *houseTV = (HouseTableViewForMap *)object;
            [houseTV removeFromSuperview];
        }
    }
    houseTableView = [[HouseTableViewForMap alloc] initWithFrame:CGRectMake(0.0, 100.0, self.view.bounds.size.width, self.view.bounds.size.height-100.0) style:UITableViewStylePlain];
    houseTableView.delegate = self;
    houseTableView.dataSource = self;
    houseTableView.backgroundColor = [UIColor redColor];
    [_mapView addSubview:houseTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    mapSearchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(20.0, 2.0, self.view.bounds.size.width-40.0, 40)];
    mapSearchBar.barStyle=UIBarStyleDefault;
    mapSearchBar.translucent=YES;
    mapSearchBar.delegate=self;
    mapSearchBar.backgroundImage=[UIImage imageNamed:@"顶部导航底色.png"];
    //mapSearchBar.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
    mapSearchBar.placeholder=@"请输入地址或小区名";
    mapSearchBar.showsCancelButton=NO;
    //mapSearchBar.userInteractionEnabled=NO;
    self.navigationItem.titleView=mapSearchBar;
    
    _locService = [[BMKLocationService alloc]init];
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    ESHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ESHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SearchViewController *searchVC=[SearchViewController shareSearchVC];
    searchVC.hidesBottomBarWhenPushed=YES;
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    searchVC.cityname=[userDefault objectForKey:@"currentCityName"];
    [self.navigationController pushViewController:searchVC animated:YES];
    //[self hiddenBackGroundForTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeESMapSearBarTitle:) name:@"esMapChangeSearBarTitle" object:nil];
    [searchBar resignFirstResponder];
    return  YES;
}

-(void)changeESMapSearBarTitle:(id)sender{
//    mapSearchBar.text=[[sender object] objectForKey:@"title"];
//    _es_searchXid=[[sender object] objectForKey:@"xid"];
//    _es_searchAreaCount=[[[sender object] objectForKey:@"count"] intValue];
//    fromSearcjVCGoBackHouseMid=[[sender object] objectForKey:@"xid"];
//    formSearchVCGoBack=YES;
//    if ([[sender object] objectForKey:@"lat"]!=[NSNull null]) {
//        fromSearcjVCGoBackHouseLat=[[sender object] objectForKey:@"lat"];
//        fromSearcjVCGoBackHouseLng=[[sender object] objectForKey:@"lng"];
//    }else{
//        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
//        fromSearcjVCGoBackHouseLat=[userDefault objectForKey:@"lat"];
//        fromSearcjVCGoBackHouseLng=[userDefault objectForKey:@"lng"];
//    }
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zMapChangeSearBarTitle" object:nil];
//    eshMapAreaList.eshsArea_xid=_es_searchXid;
//    if (self.esMapAFNetWorkManager.isLoading) {
//        //[self.esMapAFNetWorkManager cancelCurrentRequest];
//    }
//    [self.esMapAFNetWorkManager getESHouseSearchAreaList:eshMapAreaList];
//    [self showBackGroundForTableView];
//    areaTitleLabel.text=@"正在加载中...";
    
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
