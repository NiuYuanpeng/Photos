//
//  CityListViewController.m
//  YKHouse
//
//  Created by wjl on 14-6-14.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "CityListViewController.h"

@interface CityListViewController ()

@end

@implementation CityListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(void)addTableViewHeaderView{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 50.0)];
    headerView.backgroundColor=[UIColor clearColor];
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(headerView.bounds.size.width-80.0, 5.0, 60.0, 40.0);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(80.0, 5.0, headerView.bounds.size.width-160.0, 40.0)];
    titleLabel.text=@"切换城市";
    titleLabel.font=[UIFont boldSystemFontOfSize:20.0];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.backgroundColor=[UIColor clearColor];
    [headerView addSubview:titleLabel];
    
    cityListTableView.tableHeaderView=headerView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",self.cityList);
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topViewBG.png"]];
    cityListTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 20.0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    cityListTableView.delegate=self;
    cityListTableView.dataSource=self;
    cityListTableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:cityListTableView];
    [self addTableViewHeaderView];
    // Do any additional setup after loading the view.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor=[UIColor clearColor];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text=[[self.cityList objectAtIndex:indexPath.row] objectForKey:@"city"];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changBtnTitle" object:[[self.cityList objectAtIndex:indexPath.row] objectForKey:@"city"]];
    [self dismissViewControllerAnimated:YES completion:^{
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        [userDefault setObject:[[self.cityList objectAtIndex:indexPath.row] objectForKey:@"lat"] forKey:@"lat"];
        [userDefault setObject:[[self.cityList objectAtIndex:indexPath.row] objectForKey:@"lng"] forKey:@"lng"];
    }];
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
