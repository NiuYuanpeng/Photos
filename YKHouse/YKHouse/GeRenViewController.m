//
//  GeRenViewController.m
//  YKHouse
//
//  Created by wjl on 14-5-10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "GeRenViewController.h"
#import "RegisterViewController.h"
#import "MYSaveHouseViewController.h"
#import "ScanHistoryViewController.h"
#import "CenterViewController.h"
#import "AboutUsViewController.h"
#import "MyHouseSourceViewController.h"
@interface GeRenViewController ()

@end

@implementation GeRenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)addTwoLine{
    UIColor *lineColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"底部导航-蓝色条640px-3px.png"]];
    
    UILabel *secondLine=[[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.bounds.size.height-DownLineY, self.view.bounds.size.width, 2.0)];
    secondLine.backgroundColor=lineColor;
    [self.view addSubview:secondLine];
}
-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"lid"]!=nil&&[userDefault objectForKey:@"currentTelNum"]!=nil) {
        [grArray replaceObjectAtIndex:0 withObject:[userDefault objectForKey:@"currentTelNum"]];
        [grTableView reloadData];
    }else{
        [grArray replaceObjectAtIndex:0 withObject:@"登录/注册"];
        [grTableView reloadData];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>7.0) {
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
    self.navigationItem.title=@"个人中心";
    
    grTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-49.0) style:UITableViewStylePlain];
    grTableView.delegate=self;
    grTableView.dataSource=self;
    grTableView.scrollEnabled=NO;
    grTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    grTableView.backgroundColor=[UIColor clearColor];
    grTableView.sectionHeaderHeight=10.0;
    [self.view addSubview:grTableView];
    //,@"登录/注册",@"房贷计算器",
    grArray=[NSMutableArray arrayWithObjects:@"登录/注册",@"我的收藏",@"浏览历史",@"我的房源",@"关于我们", nil];
    [self addTwoLine];
    // Do any additional setup after loading the view.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[grDic objectForKey:[NSString stringWithFormat:@"%d",section]] count];
    return grArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        if (indexPath.row==-1) {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }else{
            UIImageView *accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"小于符号.png"]];
            accessoryView.frame=CGRectMake(self.view.bounds.size.width-27.0, 19.0, 7.0, 11.0);
            [cell.contentView addSubview:accessoryView];
        }
        UIImageView *lineView=[[UIImageView alloc] initWithFrame:CGRectMake(10.0, 49.0, 300.0, 1.0)];
        UIImage *img=[UIImage imageNamed:@"个人分割线.png"];
        img=[img stretchableImageWithLeftCapWidth:1 topCapHeight:0];
        lineView.image=img;
        [cell.contentView addSubview:lineView];
        
        UIImageView *signView=[[UIImageView alloc] initWithFrame:CGRectMake(20.0, 15.0, 20.0, 20.0)];
        signView.tag=77777;
        [cell.contentView addSubview:signView];
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(signView.frame.origin.x+signView.frame.size.width+10.0, signView.frame.origin.y, self.view.bounds.size.width-(signView.frame.origin.x+signView.frame.size.width+10.0+27.0), 20.0)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.tag=77778;
        [cell.contentView addSubview:titleLabel];
    }
    UIImageView *sign=(UIImageView *)[cell.contentView viewWithTag:77777];
    sign.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[grArray objectAtIndex:indexPath.row]]];
    if (indexPath.row==0) {
        sign.image=[UIImage imageNamed:@"登陆注册"];
    }
    UILabel *title=(UILabel *)[cell.contentView viewWithTag:77778];
    title.text=[grArray objectAtIndex:indexPath.row];
    title.textColor=[UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1.0];
    title.font=[UIFont systemFontOfSize:18];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        if ([[grArray objectAtIndex:indexPath.row] isEqualToString:@"登录/注册"]) {
            RegisterViewController *registerVC=[[RegisterViewController alloc] init];
            registerVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:registerVC animated:YES];
        }else{
            CenterViewController *centerVC=[[CenterViewController alloc] init];
            centerVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:centerVC animated:YES];
        }
    }else if (indexPath.row==2) {
        ScanHistoryViewController *scanHistoryVC=[[ScanHistoryViewController alloc] init];
        scanHistoryVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:scanHistoryVC animated:YES];
    }else if (indexPath.row==1){
        MYSaveHouseViewController *shVC=[[MYSaveHouseViewController alloc] init];
        shVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:shVC animated:YES];
    }else if (indexPath.row == 3){
        MyHouseSourceViewController *myHSVC = [[MyHouseSourceViewController alloc] init];
        myHSVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:myHSVC animated:YES];
    }else if (indexPath.row==4){
        AboutUsViewController *aboutUsVC=[[AboutUsViewController alloc] init];
        aboutUsVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }
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
