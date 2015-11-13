//
//  ESHouseDetailViewController.m
//  YKHouse
//
//  Created by wjl on 14-6-14.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "ESHouseDetailViewController.h"
#import "DetailInfoMapViewController.h"
#import "ShowHSPictureViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "YKSql.h"
@interface ESHouseDetailViewController ()

@end

@implementation ESHouseDetailViewController
@synthesize esnid=_nid;
@synthesize eshouseArea=_houseArea;
@synthesize escamera=_camera;
@synthesize escid=_cid;
@synthesize escommunity=_community;
@synthesize eshouseType=_houseType;
@synthesize estotalPrice=_totalPrice;
@synthesize iconurl=_iconurl;
@synthesize eshDetailArray=_eshDetailArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _esdAFNetWorkManager = [[AFNetWorkManager alloc] init];
        _esdAFNetWorkManager.delegate = self;
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
-(void)share:(UIButton *)sender{
    NSLog(@"share");
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                          SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeSMS),
                          nil];
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSContent> publishContents = [ShareSDK content:self.escommunity
                                        defaultContent:nil
                                                 image:nil
                                                 title:@"新亚企航"
                                                   url:nil
                                           description:nil
                                             mediaType:SSPublishContentMediaTypeText];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:self
                                               authManagerViewDelegate:self];
    [authOptions setPowerByHidden:YES];
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContents
                     statusBarTips:NO
                       authOptions:authOptions
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                NSLog(@"ISSPlatformShareInfo:%d",type);
                            }];
}
-(void)saveHistory:(UIButton *)sender{
    if ([[YKSql shareMysql] isExistFromSaveHouseInfo:self.esnid flag:102]) {
        if ([[YKSql shareMysql] deleteDataFromSaveHouseInfoWithNid:self.esnid flag:102]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"取消收藏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [self.view addSubview:alert];
            [alert show];
            [sender setImage:[UIImage imageNamed:@"收藏未点击.png"] forState:UIControlStateNormal];
        }
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [self.view addSubview:alert];
        [alert show];
        [self saveESHouseSource:102];//收藏存储
        [saveHistoryBtn setImage:[UIImage imageNamed:@"收藏点击.png"] forState:UIControlStateNormal];
        
        saveHouseInfo *shInfo=[[saveHouseInfo alloc] init];
        shInfo.saveh_commandcode=124;
        shInfo.saveh_nid=self.esnid;
        shInfo.saveh_username=@"";
        shInfo.housetype=@"2";
        if (self.esdAFNetWorkManager.isLoading) {
            //[self.esdAFNetWorkManager cancelCurrentRequest];
        }
        [self.esdAFNetWorkManager saveHouseSourceInfo:shInfo];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[YKSql shareMysql] isExistFromSaveHouseInfo:self.esnid flag:102]){
        [saveHistoryBtn setImage:[UIImage imageNamed:@"收藏点击.png"] forState:UIControlStateNormal];
    }else{
        [saveHistoryBtn setImage:[UIImage imageNamed:@"收藏未点击.png"] forState:UIControlStateNormal];
    }
    esHouseDetailTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-64.0) style:UITableViewStylePlain];
    esHouseDetailTableView.delegate=self;
    esHouseDetailTableView.dataSource=self;
    esHouseDetailTableView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:esHouseDetailTableView];
    
    scrollerShowV=[[ScrollerShowView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, 160)];
    scrollerShowV.delegate=self;
    esHouseDetailTableView.tableHeaderView=scrollerShowV;
    
    NSLog(@"area:%@",self.eshouseArea);
    _eshDetailArray=[[NSMutableArray alloc] init];
    esHouseDetail *eshDetail=[[esHouseDetail alloc] init];
    eshDetail.esd_nid=self.esnid;
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"currentTelNum"]==nil) {
        eshDetail.esd_tel=@"";
    }else{
        eshDetail.esd_tel=[userDefault objectForKey:@"currentTelNum"];
    }
    if (self.esdAFNetWorkManager.isLoading) {
        //[self.esdAFNetWorkManager cancelCurrentRequest];
    }
    [self.esdAFNetWorkManager getESHouseDetail:eshDetail];
    [self addHUDView];
    // Do any additional setup after loading the view.
}

-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    NSLog(@"%@",resultDic);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (isSuccess) {
        if (code==ESHouseDetail_CommandCode) {
            [self.eshDetailArray addObjectsFromArray:[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"]];
            if (self.eshDetailArray.count>0) {
                scrollerShowV.imageArray=[[self.eshDetailArray objectAtIndex:0] objectForKey:@"image"];
                [scrollerShowV setNeedsDisplay];
                [self saveESHouseSource:105];//浏览历史存储
            }
            [esHouseDetailTableView reloadData];
        }else if (code==124){
//            NSArray *arr=[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
//            if (arr.count>0) {
//                if ([[[arr objectAtIndex:0] objectForKey:@"state"] integerValue]==0) {
//                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [self.view addSubview:alert];
//                    [alert show];
//                    [self saveESHouseSource:102];//收藏存储
//                    [saveHistoryBtn setImage:[UIImage imageNamed:@"收藏点击.png"] forState:UIControlStateNormal];
//                    return;
//                }
//            }
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"收藏失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [self.view addSubview:alert];
//            [alert show];
            
        }
    }
}
-(void)saveESHouseSource:(int)flage{
    NSString *hArea=@"暂无";
    NSString *rentStyle=@"暂无";
    NSString *sampleAdd=@"暂无";
    if (self.eshDetailArray.count>0) {
        sampleAdd=[[self.eshDetailArray objectAtIndex:0] objectForKey:@"add"];
    }
    hArea=self.eshouseArea;
    NSString *hPrice=self.estotalPrice;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    [[YKSql shareMysql]insert:[NSString stringWithFormat:@"INSERT OR REPLACE INTO saveHouseInfoTable (nid,flag,houseName,houseTitle,houseArea,price,rentStyle,hStyle,sampleAddress,iconurl,saveDate) values ('%@','%d','%@','%@','%@','%@','%@','%@','%@','%@','%@')",self.esnid,flage,self.escommunity,self.titleNameStr,hArea,hPrice,rentStyle,self.eshouseType,sampleAdd,self.iconurl,date]];
}
#pragma mark - ScrollerShowViewDelegate
-(void)didSelectedImageViewForShowViewUrlpath:(NSString *)urlpath currentPage:(int)curPage{
    NSLog(@"didSelectedImageViewForShowViewUrlpath");
    ShowHSPictureViewController *showPicVC=[[ShowHSPictureViewController alloc] init];
    showPicVC.showPics=[[self.eshDetailArray objectAtIndex:0] objectForKey:@"image"];
    showPicVC.currentPage=curPage;
    [self.navigationController pushViewController:showPicVC animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[grDic objectForKey:[NSString stringWithFormat:@"%d",section]] count];
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell-%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topViewBG.png"]];
    cell.textLabel.numberOfLines=0;
    UIFont *font=[UIFont systemFontOfSize:14.0];
    cell.textLabel.font=font;
    if (indexPath.row==0) {
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.text=self.escommunity;
        cell.textLabel.font=[UIFont boldSystemFontOfSize:16.0];
    }else if (indexPath.row==1){
        UILabel *totalLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 5.0, (ScreenWidth-30.0)/2.0+35.0, 20.0)];
        totalLabel.font=font;
        totalLabel.text=[NSString stringWithFormat:@"售价: %@万元",self.estotalPrice];
        [cell.contentView addSubview:totalLabel];
        
        UILabel *lcLabel=[[UILabel alloc] initWithFrame:CGRectMake(totalLabel.frame.origin.x, totalLabel.frame.origin.y+totalLabel.frame.size.height+5.0, totalLabel.frame.size.width, 20.0)];
        lcLabel.font=font;
        [cell.contentView addSubview:lcLabel];
        
        UILabel *cxLabel=[[UILabel alloc] initWithFrame:CGRectMake(totalLabel.frame.origin.x+totalLabel.frame.size.width, totalLabel.frame.origin.y+25.0, totalLabel.frame.size.width-70.0, 20.0)];
        cxLabel.font=font;
        [cell.contentView addSubview:cxLabel];
        
        UILabel *fxLabel=[[UILabel alloc] initWithFrame:CGRectMake(totalLabel.frame.origin.x, lcLabel.frame.origin.y+lcLabel.frame.size.height+5.0, totalLabel.frame.size.width, 20.0)];
        fxLabel.text=[NSString stringWithFormat:@"房型: %@",self.eshouseType];
        fxLabel.font=font;
        [cell.contentView addSubview:fxLabel];
        
        UILabel *zxLabel=[[UILabel alloc] initWithFrame:CGRectMake(totalLabel.frame.origin.x+totalLabel.frame.size.width, cxLabel.frame.origin.y+cxLabel.frame.size.height+5.0, cxLabel.frame.size.width, 20.0)];
        zxLabel.font=font;
        [cell.contentView addSubview:zxLabel];
        
        UILabel *mjLabel=[[UILabel alloc] initWithFrame:CGRectMake(totalLabel.frame.origin.x, fxLabel.frame.origin.y+fxLabel.frame.size.height+5.0, fxLabel.frame.size.width, 20.0)];
        mjLabel.text=[NSString stringWithFormat:@"面积: %@平方米",self.eshouseArea];
        mjLabel.font=font;
        [cell.contentView addSubview:mjLabel];
        
        UILabel *ndLabel=[[UILabel alloc] initWithFrame:CGRectMake(totalLabel.frame.origin.x+totalLabel.frame.size.width, mjLabel.frame.origin.y, mjLabel.frame.size.width, 20.0)];
        ndLabel.font=font;
        [cell.contentView addSubview:ndLabel];
        
        if (self.eshDetailArray.count>0) {
            zxLabel.text=[NSString stringWithFormat:@"装修: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"fitment"]];
            cxLabel.text=[NSString stringWithFormat:@"朝向: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"toward"]];
            lcLabel.text=[NSString stringWithFormat:@"楼层: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"floor"]];
            ndLabel.text=[NSString stringWithFormat:@"年代: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"years"]];
            cxLabel.text=@"朝向: 暂无";
        }else{
            lcLabel.text=@"楼层: 暂无";
            zxLabel.text=@"装修: 暂无";
            cxLabel.text=@"朝向: 暂无";
            ndLabel.text=@"年代: 暂无";
        }
    }else if(indexPath.row==2){
        UILabel *communityName=[[UILabel alloc] initWithFrame:CGRectMake(15, 5.0, ScreenWidth, 20.0)];
        communityName.font=font;
        communityName.text=[NSString stringWithFormat:@"小区: %@",self.titleNameStr];
        [cell.contentView addSubview:communityName];
        
        UILabel *address=[[UILabel alloc] initWithFrame:CGRectMake(communityName.frame.origin.x, communityName.frame.origin.y+communityName.frame.size.height+5.0, communityName.frame.size.width-30.0, 20.0)];
        address.font=font;
        [cell.contentView addSubview:address];
        
        UIButton *locationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [locationBtn setImage:[UIImage imageNamed:@"详情-定位符号.png"] forState:UIControlStateNormal];
        [locationBtn addTarget:self action:@selector(goToMapView) forControlEvents:UIControlEventTouchUpInside];
        locationBtn.frame=CGRectMake(ScreenWidth-40, address.frame.origin.x-10.0, 28.0, 45.0);
        [cell.contentView addSubview:locationBtn];
        
        if (self.eshDetailArray.count>0) {
            address.text=[NSString stringWithFormat:@"地址: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"add"]];
        }else{
            address.text=@"地址: 暂无";
        }
    }else if (indexPath.row==3){
        if (self.eshDetailArray.count>0&&[[self.eshDetailArray objectAtIndex:0] objectForKey:@"desc"]!=[NSNull null]) {
            cell.textLabel.text=[NSString stringWithFormat:@"详细描述: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"desc"]];
        }else{
            cell.textLabel.text=@"详细描述: 暂无";
        }
    }else if (indexPath.row==4){
        if (self.eshDetailArray.count>0&&[[self.eshDetailArray objectAtIndex:0] objectForKey:@"business"]!=[NSNull null]) {
            cell.textLabel.text=[NSString stringWithFormat:@"商业百货: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"business"]];
        }else{
            cell.textLabel.text=@"商业百货: 暂无";
        }
    }else if (indexPath.row==5){
        if (self.eshDetailArray.count>0&&[[self.eshDetailArray objectAtIndex:0] objectForKey:@"environmental"]!=[NSNull null]) {
            cell.textLabel.text=[NSString stringWithFormat:@"周边环境: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"environmental"]];
        }else{
            cell.textLabel.text=@"周边环境: 暂无";
        }
    }else if (indexPath.row==6){
        if (self.eshDetailArray.count>0&&[[self.eshDetailArray objectAtIndex:0] objectForKey:@"entertainment"]!=[NSNull null]) {
            cell.textLabel.text=[NSString stringWithFormat:@"休闲娱乐: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"entertainment"]];
        }else{
            cell.textLabel.text=@"休闲娱乐: 暂无";
        }
    }else if (indexPath.row==7){
        if (self.eshDetailArray.count>0&&[[self.eshDetailArray objectAtIndex:0] objectForKey:@"education"]!=[NSNull null]) {
            cell.textLabel.text=[NSString stringWithFormat:@"学校教育: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"education"]];
        }else{
            cell.textLabel.text=@"学校教育: 暂无";
        }
    }else if (indexPath.row==8){
        if (self.eshDetailArray.count>0&&[[self.eshDetailArray objectAtIndex:0] objectForKey:@"facility"]!=[NSNull null]) {
            cell.textLabel.text=[NSString stringWithFormat:@"交通状况 : %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"facility"]];
        }else{
            cell.textLabel.text=@"交通状况 : 暂无";
        }
    }else if (indexPath.row==9){
        UIImageView *brokerView=[[UIImageView alloc] initWithFrame:CGRectMake(10.0, 15.0, 85*2/3, 112*2/3)];
        brokerView.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:brokerView];
        
        UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(80.0, 20.0, cell.frame.size.width, 20.0)];
        name.text=[NSString stringWithFormat:@"售价: %@万元",self.estotalPrice];
        name.font=font;
        [cell.contentView addSubview:name];
        
        UILabel *teleNumber=[[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x, name.frame.origin.y+name.frame.size.height+20.0, name.frame.size.width/2.0+10.0, 20.0)];
        teleNumber.text=[NSString stringWithFormat:@"房型: %@",self.eshouseType];
        teleNumber.font=font;
        [cell.contentView addSubview:teleNumber];
        
        UIButton *callBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        callBtn.frame=CGRectMake(self.view.bounds.size.width-80.0, 22.0, 60.0, 60.0);
        [callBtn addTarget:self action:@selector(callTelePhoen) forControlEvents:UIControlEventTouchUpInside];
        [callBtn setImage:[UIImage imageNamed:@"拨打未点击.png"] forState:UIControlStateNormal];
        [callBtn setImage:[UIImage imageNamed:@"拨打点击.png"] forState:UIControlStateHighlighted];
        [cell.contentView addSubview:callBtn];
        name.text=@"姓名: 暂无";
        teleNumber.text=@"电话: 暂无";

        if (self.eshDetailArray.count>0) {
            if ([[self.eshDetailArray objectAtIndex:0] objectForKey:@"mob"] !=[NSNull null]) {
               teleNumber.text=[NSString stringWithFormat:@"电话: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"mob"]];
            }
            if ([[self.eshDetailArray objectAtIndex:0] objectForKey:@"name"] !=[NSNull null]){
                name.text=[NSString stringWithFormat:@"姓名: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"name"]];
            }
            
            NSString *stringImagePath =[NSString stringWithFormat:@"%@%@",PictureAddress,[[self.eshDetailArray objectAtIndex:0] objectForKey:@"namepath"]];
            NSLog(@"imagePath:%@",stringImagePath);
            NSString *imagePath = [stringImagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSLog(@"imagePath:%@",imagePath);
            
            [brokerView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"listLoad.png"]];
            
            //[brokerView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureAddress,[[self.eshDetailArray objectAtIndex:0] objectForKey:@"namepath"]]]];
        }
    }
    return cell;
}
-(void)goToMapView{
    NSLog(@"定位到具体地址");
    if (self.eshDetailArray.count>0) {
        DetailInfoMapViewController *detailMapVC=[[DetailInfoMapViewController alloc] init];
        detailMapVC.lat=[[self.eshDetailArray objectAtIndex:0] objectForKey:@"lat"];
        detailMapVC.lng=[[self.eshDetailArray objectAtIndex:0] objectForKey:@"lng"];
        detailMapVC.houseTitle=self.titleNameStr;
        [self.navigationController pushViewController:detailMapVC animated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"暂时没有具体地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [self.view addSubview:alert];
        [alert show];
        return;

    }
    
}
-(void)callTelePhoen{
    if (self.eshDetailArray.count>0) {
        if ([[self.eshDetailArray objectAtIndex:0] objectForKey:@"mob"] !=[NSNull null]) {
            NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"mob"]];
            NSURL *url = [[NSURL alloc] initWithString:telUrl];
            [[UIApplication sharedApplication] openURL:url];
            return;
        }
    }
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"暂时没有联系电话!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [self.view addSubview:alert];
    [alert show];
    
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(float)getLabelHeight:(NSString *)text{
    CGSize titleSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(self.view.frame.size.width-40.0, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    if (titleSize.height>40.0) {
        return titleSize.height+20.0;
    }
    return 40.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row==1||indexPath.row==9){
        return 105.0;
    }else if (indexPath.row==2){
        return 55.0;
    }else if (indexPath.row==3){
        if (self.eshDetailArray.count>0&&[[self.eshDetailArray objectAtIndex:0] objectForKey:@"desc"]!=[NSNull null]) {
            return [self getLabelHeight:[NSString stringWithFormat:@"详细描述: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"desc"]]];
        }else{
            return 40.0;
        }
    }else if (indexPath.row==4){
        if (self.eshDetailArray.count>0&&[[self.eshDetailArray objectAtIndex:0] objectForKey:@"business"]!=[NSNull null]) {
            return [self getLabelHeight:[NSString stringWithFormat:@"商业百货: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"business"]]];
        }else{
            return 40.0;
        }
    }else if (indexPath.row==5){
        if (self.eshDetailArray.count>0&&[[self.eshDetailArray objectAtIndex:0] objectForKey:@"environmental"]!=[NSNull null]) {
            return [self getLabelHeight:[NSString stringWithFormat:@"周边环境: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"environmental"]]];
        }else{
            return 40.0;
        }
    }else if (indexPath.row==6){
        if (self.eshDetailArray.count>0&&[[self.eshDetailArray objectAtIndex:0] objectForKey:@"entertainment"]!=[NSNull null]) {
            return [self getLabelHeight:[NSString stringWithFormat:@"休闲娱乐: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"entertainment"]]];
        }else{
            return 40.0;
        }
    }else if (indexPath.row==7){
        if (self.eshDetailArray.count>0&&[[self.eshDetailArray objectAtIndex:0] objectForKey:@"education"]!=[NSNull null]) {
            return [self getLabelHeight:[NSString stringWithFormat:@"学校教育: %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"education"]]];
        }else{
            return 40.0;
        }
    }else if (indexPath.row==8){
        if (self.eshDetailArray.count>0&&[[self.eshDetailArray objectAtIndex:0] objectForKey:@"facility"]!=[NSNull null]) {
            return [self getLabelHeight:[NSString stringWithFormat:@"交通状况 : %@",[[self.eshDetailArray objectAtIndex:0] objectForKey:@"facility"]]];
        }else{
            return 30.0;
        }
    }
    return 40.0;
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
