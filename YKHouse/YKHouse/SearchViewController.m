//
//  SearchViewController.m
//  YKHouse
//
//  Created by wjl on 14-6-16.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize searchArray=_searchArray;
@synthesize cityname=_cityname;
@synthesize keyword=_keyword;
@synthesize commandcode=_commandcode;
@synthesize currentCommandCode=_currentCommandCode;
static SearchViewController *searchVC=nil;
+(instancetype)shareSearchVC{
    if (searchVC==nil) {
        searchVC=[[self alloc] init];
    }
    
    return searchVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _searchAFNetWorkManager = [[AFNetWorkManager alloc] init];
        _searchAFNetWorkManager.delegate = self;
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [sBar becomeFirstResponder];
    if (searchVC.currentCommandCode!=searchVC.commandcode) {
        [searchVC.searchArray removeAllObjects];
        [searchVC.searchTableView reloadData];
        sBar.text=@"";
        searchVC.currentCommandCode=searchVC.commandcode;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    //[searchBar isFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
    sBar=[[UISearchBar alloc] initWithFrame:CGRectMake(10.0, 2.0, self.view.bounds.size.width-20.0, 40)];
    sBar.barStyle=UIBarStyleDefault;
    sBar.translucent=YES;
    sBar.delegate=self;
    sBar.backgroundImage=[UIImage imageNamed:@"顶部导航底色.png"];
    sBar.placeholder=@"请输入地址或小区名";
    sBar.showsCancelButton=YES;
    self.navigationItem.titleView=sBar;
    _searchTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, NavigationBarLineY, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _searchTableView.rowHeight=40.0;
    _searchTableView.delegate=self;
    _searchTableView.dataSource=self;
    [self.view addSubview:_searchTableView];
    
    _searchArray=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}
#pragma mark - AFNetWorkManagerDelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    if (isSuccess) {
        NSLog(@"%@",resultDic);
        [self.searchArray removeAllObjects];
        [self.searchArray addObjectsFromArray:[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"]];
        [self.searchTableView reloadData];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.searchArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text=[[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    sBar.text=[[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSDictionary *dic=[self.searchArray objectAtIndex:indexPath.row];
    if (self.commandcode==ESHouseSearchArea_CommandCode) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"esMapChangeSearBarTitle" object:dic];
    }else if (self.commandcode==114){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"zMapChangeSearBarTitle" object:dic];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchBarSearchButtonClicked%d",self.commandcode);
    [searchBar resignFirstResponder];
    if (self.commandcode==ESHouseSearchArea_CommandCode) {
        esHouseSearch *eshSearch=[[esHouseSearch alloc] init];
        eshSearch.eshSearch_cityname=self.cityname;
        eshSearch.eshSearch_keyword=sBar.text;
        if (self.searchAFNetWorkManager.isLoading) {
            //[self.searchAFNetWorkManager cancelCurrentRequest];
        }
        [self.searchAFNetWorkManager getESHouseSearchArea:eshSearch];
    }else if (self.commandcode==114){
        zHouseSearch *zhSearch=[[zHouseSearch alloc] init];
        zhSearch.zhSearch_commandcode=114;
        zhSearch.zhSearch_cityname=self.cityname;
        zhSearch.zhSearch_keyword=sBar.text;
        if (self.searchAFNetWorkManager.isLoading) {
            //[self.searchAFNetWorkManager cancelCurrentRequest];
        }
        [self.searchAFNetWorkManager getZHouseSearchArea:zhSearch];
    }
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    //隐藏横线和uitabbar
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    
    sBar.showsCancelButton=YES;//必须放在遍历UISearchBar的subviews之前
    CGFloat searBarX,searchBarWidth;
    if ([UIDevice currentDevice].systemVersion.doubleValue<7.0) {
        for (UIView *searchbuttons in sBar.subviews)
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
        UIView *subView=[sBar.subviews objectAtIndex:0];
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
    
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    //mapSearchBar.text=@"";
    [sBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [sBar resignFirstResponder];
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
