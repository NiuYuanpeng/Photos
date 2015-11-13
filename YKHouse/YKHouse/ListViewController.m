//
//  ListViewController.m
//  YKHouse
//
//  Created by wjl on 14-6-13.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "ListViewController.h"
#import "CityListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    mySearchBar.hidden=NO;
    [mySearchBar resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    mySearchBar.hidden=YES;
}

-(void)addDownLine{
    UIColor *lineColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"底部导航-蓝色条640px-3px.png"]];
    secondLine=[[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.bounds.size.height-DownLineY, self.view.bounds.size.width, 2.0)];
    secondLine.backgroundColor=lineColor;
    [self.view addSubview:secondLine];
}

-(void)addNavigationBarSubviews{
    leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0.0 , 0.0, 40.0, 40.0);
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [leftBtn setTitle:[userDefault objectForKey:@"currentCityName"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBarBtnItem=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=leftBarBtnItem;
    
    rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0.0 , 0.0, 40.0, 40.0);
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [rightBtn addTarget:self action:@selector(mapBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"地图" forState:UIControlStateNormal];
    rightBarBtnItem=[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightBarBtnItem;
    
    mySearchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(20.0, 2.0, self.view.bounds.size.width-40.0, 40)];
    mySearchBar.barStyle=UISearchBarStyleDefault;
    mySearchBar.translucent=YES;
    mySearchBar.backgroundImage=[UIImage imageNamed:@"顶部导航底色.png"];
    //mySearchBar.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
    mySearchBar.placeholder=@"请输入地址或小区名";
    mySearchBar.showsCancelButton=NO;
    self.navigationItem.titleView=mySearchBar;
    //[self.navigationController.navigationBar addSubview:mySearchBar];
    
}

-(void)cityBtnClicked:(UIButton *)btn{
    NSLog(@"ListViewController--cityBtn");
    [mySearchBar resignFirstResponder];
}
-(void)mapBtnClicked:(UIButton *)btn{
    NSLog(@"ListViewController--mapBtn");
    [mySearchBar resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
    [self addNavigationBarSubviews];
    
    houseTopV=[[HouseTopView alloc] initWithFrame:CGRectMake(0.0, NavigationBarLineY, self.view.bounds.size.width, TopViewHeight)];
    [self.view addSubview:houseTopV];
    
    listTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, houseTopV.frame.size.height+NavigationBarLineY, self.view.bounds.size.width, self.view.bounds.size.height-NavigationBarLineY-houseTopV.frame.size.height-49.0-OtherHeight) style:UITableViewStylePlain];
    listTableView.rowHeight=100.0;
    [self.view addSubview:listTableView];
    
    searchTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, NavigationBarLineY, self.view.bounds.size.width, self.view.bounds.size.height-NavigationBarLineY-OtherHeight) style:UITableViewStylePlain];
    searchTableView.rowHeight=40.0;
    searchTableView.hidden=YES;
    [self.view addSubview:searchTableView];
    
    gmView=[[GetMoreLoadView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50.0)];
    
    siftConditionV=[[XYSiftConditionView alloc] initWithFrame:CGRectMake(0.0, houseTopV.frame.origin.y+houseTopV.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-NavigationBarLineY-90.0-OtherHeight)];
    [self.view addSubview:siftConditionV];
    
    [self addDownLine];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>7.0) {
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
    // Do any additional setup after loading the view.
}



#pragma mark - AFNetWorkManagerDelegate
-(void)didRequestForSuperVCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    if (isSuccess) {
        NSLog(@"%@",resultDic);
        //NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:resultDic];
        NSMutableArray *array=(NSMutableArray *)[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
        if (array.count>0) {
            CityListViewController *cityListVC=[[CityListViewController alloc] init];
            cityListVC.cityList=[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
            [self presentViewController:cityListVC animated:YES completion:^{
                
            }];
        }
    }else{
        
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    return cell;
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
