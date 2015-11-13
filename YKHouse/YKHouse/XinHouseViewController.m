//
//  XinHouseViewController.m
//  YKHouse
//
//  Created by wjl on 14-5-10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "XinHouseViewController.h"
#import "XHouseTableViewCell.h"
#import "ZHouseDetailInfoViewController.h"
@interface XinHouseViewController ()

@end

@implementation XinHouseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)hiddenSiftConditionView{
    siftConditionV.hidden=YES;
//    siftConditionV.firstLeftCurrentIndex=siftConditionV.firstTempIndex;
//    siftConditionV.secondLeftCurrentIndex=siftConditionV.secondTempIndex;
//    siftConditionV.thirdLeftCurrentIndex=siftConditionV.thirdTempIndex;
}
-(void)viewWillAppear:(BOOL)animated{
    mySearchBar.hidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    mySearchBar.hidden=YES;
}

-(void)mapBtnClicked:(UIButton *)btn{
    NSLog(@"----map");
    [mySearchBar resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
    
    NSString *titlePath=[[NSBundle mainBundle] pathForResource:@"SiftNTitle" ofType:@"plist"];
    segmentTitleA=[[NSMutableArray alloc] initWithContentsOfFile:titlePath];
    houseTopV.delegate=self;
    houseTopV.selectButtonTitleArray=segmentTitleA;
    [houseTopV showButtonsTitle];
    
    listTableView.delegate=self;
    listTableView.dataSource=self;
    
    NSArray *areaArray=(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"area"];
    [siftConditionV.firstArray addObjectsFromArray:areaArray];
    
    NSString *segmentLPPath=[[NSBundle mainBundle] pathForResource:@"SiftNLP" ofType:@"plist"];
    NSArray *LPDicTemple=(NSArray *)[[NSArray alloc] initWithContentsOfFile:segmentLPPath];
    [siftConditionV.secondArray addObjectsFromArray:LPDicTemple];
    
    NSString *segmentLPQYPath=[[NSBundle mainBundle] pathForResource:@"SiftNMore" ofType:@"plist"];
    NSArray *LPQYDetailDicTemple=(NSArray *)[[NSArray alloc] initWithContentsOfFile:segmentLPQYPath];
    [siftConditionV.thirdArray addObjectsFromArray:LPQYDetailDicTemple];
    siftConditionV.segmentTitleArray=segmentTitleA;
    [self hiddenSiftConditionView];

    siftConditionV.delegate=self;
//    
    // Do any additional setup after loading the view.
}
#pragma mark - SiftConditionDelegate
-(void)siftConditionViewSelectedSegmentIndex:(NSInteger)segmentIndex didSelectedLeftTableVCellString:(NSString *)textForLeftSelectedCell leftSelectedCellIndex:(NSInteger)leftIndex didSelectedRightTableVCellString:(NSString *)textForRightSelectedCell rightSelectedCellIndex:(NSInteger)rightIndex title:(NSString *)titleForSelelctedBtn{
    
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
//    siftConditionV.firstLeftCurrentIndex=siftConditionV.firstTempIndex;
//    siftConditionV.secondLeftCurrentIndex=siftConditionV.secondTempIndex;
//    siftConditionV.thirdLeftCurrentIndex=siftConditionV.thirdTempIndex;
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZHouseDetailInfoViewController *zHouseDetailInfoVC=[[ZHouseDetailInfoViewController alloc] init];
    zHouseDetailInfoVC.titleNameStr=@"开祥御龙城";
    zHouseDetailInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zHouseDetailInfoVC animated:YES];
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
