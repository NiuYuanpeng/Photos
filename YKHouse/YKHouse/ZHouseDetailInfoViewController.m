//
//  ZHouseDetailInfoViewController.m
//  YKHouse
//
//  Created by wjl on 14-5-12.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "ZHouseDetailInfoViewController.h"
//#import "ZHouseIntroTableViewCell.h"
//#import "ZHouseTableViewCell.h"
//#import "BrokeredTableViewCell.h"
#import "DetailInfoMapViewController.h"
#import "ShowHSPictureViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "YKSql.h"
@interface ZHouseDetailInfoViewController ()

@end

@implementation ZHouseDetailInfoViewController
@synthesize nid=_nid;
@synthesize zhDetailArray=_zhDetailArray;
@synthesize zcamera=_zcamera;
@synthesize zcid=_zcid;
@synthesize zcommunity=_zcommunity;
@synthesize zhouseType=_zhouseType;
@synthesize zPrice=_zPrice;
@synthesize iconurl=_iconurl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _zdAFNetWorkManager = [[AFNetWorkManager alloc] init];
        _zdAFNetWorkManager.delegate = self;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    //self.navigationController.navigationBarHidden=NO;
    
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
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.iconurl]];
    UIImage *img=[UIImage imageWithData:data];
    //加入分享的图片
    id<ISSCAttachment> shareImage = nil;
    SSPublishContentMediaType shareType = SSPublishContentMediaTypeText;
    if(img)
    {
        shareImage = [ShareSDK pngImageWithImage:img];
        shareType = SSPublishContentMediaTypeNews;
    }
   
    NSLog(@"%@",self.zcommunity);
    
    id<ISSContent> publishContents = [ShareSDK content:self.zcommunity
                                        defaultContent:nil
                                                 image:shareImage
                                                 title:self.zcommunity
                                                   url:nil
                                           description:nil
                                             mediaType:shareType];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:self
                                               authManagerViewDelegate:self];
    [authOptions setPowerByHidden:YES];
    
    //分享内容
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContents
                     statusBarTips:NO
                       authOptions:authOptions
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                NSLog(@"ISSPlatformShareInfo:%d",type);
                            }];
}

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType{
    [viewController.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:89/255.0 green:154/255.0 blue:167/255.0 alpha:1.0]];
    if (shareType==1) {
        //viewController.title=@"新浪微博授权";
    }else{
        viewController.title=@"腾讯微博授权";
    }
    
}
-(void)saveHistory:(UIButton *)sender{
    NSLog(@"b");
    if ([[YKSql shareMysql] isExistFromSaveHouseInfo:self.nid flag:101]) {
        if ([[YKSql shareMysql] deleteDataFromSaveHouseInfoWithNid:self.nid flag:101]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"取消收藏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [self.view addSubview:alert];
            [alert show];
            [sender setImage:[UIImage imageNamed:@"收藏未点击.png"] forState:UIControlStateNormal];
        }
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [self.view addSubview:alert];
        [alert show];
        [self saveHouseSource:101];//收藏房源
        [saveHistoryBtn setImage:[UIImage imageNamed:@"收藏点击.png"] forState:UIControlStateNormal];
        
        saveHouseInfo *shInfo=[[saveHouseInfo alloc] init];
        shInfo.saveh_commandcode=124;
        shInfo.saveh_nid=self.nid;
        shInfo.saveh_username=@"";
        shInfo.housetype=@"1";
        if (self.zdAFNetWorkManager.isLoading) {
            //[self.zdAFNetWorkManager cancelCurrentRequest];
        }
        [self.zdAFNetWorkManager saveHouseSourceInfo:shInfo];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    if ([[YKSql shareMysql] isExistFromSaveHouseInfo:self.nid flag:101]){
        [saveHistoryBtn setImage:[UIImage imageNamed:@"收藏点击.png"] forState:UIControlStateNormal];
    }else{
        [saveHistoryBtn setImage:[UIImage imageNamed:@"收藏未点击.png"] forState:UIControlStateNormal];
    }
    zHouseDetailTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-64.0) style:UITableViewStylePlain];
    zHouseDetailTableView.delegate=self;
    zHouseDetailTableView.dataSource=self;
    //zHouseDetailTableView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:zHouseDetailTableView];
    
    scrollerShowV=[[ScrollerShowView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, 160)];
    scrollerShowV.delegate=self;
    zHouseDetailTableView.tableHeaderView=scrollerShowV;
    _zhDetailArray=[[NSMutableArray alloc] init];
    zHouseDetail *zhDetail=[[zHouseDetail alloc] init];
    zhDetail.zd_nid=self.nid;
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"currentTelNum"]==nil) {
        zhDetail.tel=@"";
    }else{
        zhDetail.tel=[userDefault objectForKey:@"currentTelNum"];
    }
    if (self.zdAFNetWorkManager.isLoading) {
        //[self.zdAFNetWorkManager cancelCurrentRequest];
    }
    [self.zdAFNetWorkManager getZHouseDetail:zhDetail];
    [self addHUDView];
    // Do any additional setup after loading the view.
}
#pragma mark - AFNetworkManagerDelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    NSLog(@"%@",resultDic);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (isSuccess) {
        if (code==ZHouseDetail_CommandCode) {
            [self.zhDetailArray addObjectsFromArray:[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"]];
            if (self.zhDetailArray.count>0) {
                scrollerShowV.imageArray=[[self.zhDetailArray objectAtIndex:0] objectForKey:@"image"];
                [scrollerShowV setNeedsDisplay];
                [self saveHouseSource:104];//浏览历史
            }
            [zHouseDetailTableView reloadData];
        }else if (code==124){
//            NSArray *arr=[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"];
//            if (arr.count>0) {
//                if ([[[arr objectAtIndex:0] objectForKey:@"state"] integerValue]==0) {
//                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [self.view addSubview:alert];
//                    [alert show];
//                    [self saveHouseSource:101];//收藏房源
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
-(void)saveHouseSource:(int)flag{
    NSString *hArea=@"暂无";
    NSString *rentStyle=@"暂无";
    NSString *sampleAdd=@"暂无";
    if (self.zhDetailArray.count>0) {
        hArea=[[self.zhDetailArray objectAtIndex:0] objectForKey:@"area"];
        rentStyle=[[self.zhDetailArray objectAtIndex:0] objectForKey:@"state"];
        sampleAdd=[[self.zhDetailArray objectAtIndex:0] objectForKey:@"address"];
    }
    NSString *hPrice=[NSString stringWithFormat:@"%d",self.zPrice];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    [[YKSql shareMysql]insert:[NSString stringWithFormat:@"INSERT OR REPLACE INTO saveHouseInfoTable (nid,flag,houseName,houseTitle,houseArea,price,rentStyle,hStyle,sampleAddress,iconurl,saveDate) values ('%@','%d','%@','%@','%@','%@','%@','%@','%@','%@','%@')",self.nid,flag,self.zcommunity,self.titleNameStr,hArea,hPrice,rentStyle,self.zhouseType,sampleAdd,self.iconurl,date]];
}
#pragma mark - ScrollerShowViewDelegate
-(void)didSelectedImageViewForShowViewUrlpath:(NSString *)urlpath currentPage:(int)curPage{
    NSLog(@"didSelectedImageViewForShowViewUrlpath");
    ShowHSPictureViewController *showPicVC=[[ShowHSPictureViewController alloc] init];
    showPicVC.showPics=[[self.zhDetailArray objectAtIndex:0] objectForKey:@"image"];
    showPicVC.currentPage=curPage;
    [self.navigationController pushViewController:showPicVC animated:YES];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlpath]];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[grDic objectForKey:[NSString stringWithFormat:@"%d",section]] count];
    return 11;
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
        NSLog(@"%@",self.zcommunity);
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.text=self.zcommunity;
        cell.textLabel.font=[UIFont boldSystemFontOfSize:16.0];
    }else if (indexPath.row==1){
        UILabel *rentLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 5.0, cell.frame.size.width, 20.0)];
        rentLabel.text=[NSString stringWithFormat:@"租金: %d元/月",self.zPrice];
        rentLabel.font=font;
        rentLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:rentLabel];
        
        UILabel *fxLabel=[[UILabel alloc] initWithFrame:CGRectMake(rentLabel.frame.origin.x, rentLabel.frame.origin.y+rentLabel.frame.size.height+5.0, rentLabel.frame.size.width/2.0+10.0, 20.0)];
        fxLabel.text=[NSString stringWithFormat:@"房型: %@",self.zhouseType];
        fxLabel.font=font;
        fxLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:fxLabel];
        
        
        UILabel *zxLabel=[[UILabel alloc] initWithFrame:CGRectMake(fxLabel.frame.origin.x+fxLabel.frame.size.width+20.0, fxLabel.frame.origin.y, rentLabel.frame.size.width/2.0-10.0, 20.0)];
        zxLabel.font=font;
        zxLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:zxLabel];
        
        UILabel *mjLabel=[[UILabel alloc] initWithFrame:CGRectMake(rentLabel.frame.origin.x, fxLabel.frame.origin.y+fxLabel.frame.size.height+5.0, fxLabel.frame.size.width, 20.0)];
        mjLabel.font=font;
        mjLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:mjLabel];
        
        UILabel *cxLabel=[[UILabel alloc] initWithFrame:CGRectMake(zxLabel.frame.origin.x, mjLabel.frame.origin.y, zxLabel.frame.size.width, 20.0)];
        cxLabel.font=font;
        cxLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:cxLabel];
        
        UILabel *lcLabel=[[UILabel alloc] initWithFrame:CGRectMake(rentLabel.frame.origin.x, mjLabel.frame.origin.y+mjLabel.frame.size.height+5.0, mjLabel.frame.size.width, 20.0)];
        lcLabel.font=font;
        lcLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lcLabel];
        
        UILabel *lxLabel=[[UILabel alloc] initWithFrame:CGRectMake(cxLabel.frame.origin.x, lcLabel.frame.origin.y, cxLabel.frame.size.width, 20.0)];
        lxLabel.font=font;
        lxLabel.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lxLabel];
        
        if (self.zhDetailArray.count>0) {
            fxLabel.text=[NSString stringWithFormat:@"房型: %@(%@)",self.zhouseType,[[self.zhDetailArray objectAtIndex:0] objectForKey:@"state"]];
            zxLabel.text=[NSString stringWithFormat:@"装修: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"fitment"]];
            mjLabel.text=[NSString stringWithFormat:@"面积: %@平方米",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"area"]];
            cxLabel.text=[NSString stringWithFormat:@"朝向: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"toward"]];
            lcLabel.text=[NSString stringWithFormat:@"楼层: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"floor"]];
            lxLabel.text=[NSString stringWithFormat:@"类型: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"type"]];
        }else{
            zxLabel.text=@"装修: 暂无";
            mjLabel.text=@"面积: 暂无";
            cxLabel.text=@"朝向: 暂无";
            lcLabel.text=@"楼层: 暂无";
            lxLabel.text=@"类型: 暂无";
        }
    }else if(indexPath.row==2){
        UILabel *communityName=[[UILabel alloc] initWithFrame:CGRectMake(15, 5.0, ScreenWidth, 20.0)];
        communityName.font=font;
        communityName.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:communityName];
        
        UILabel *address=[[UILabel alloc] initWithFrame:CGRectMake(communityName.frame.origin.x, communityName.frame.origin.y+communityName.frame.size.height+5.0, communityName.frame.size.width-30.0, 20.0)];
        address.font=font;
        address.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:address];
        
        UIButton *locationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [locationBtn setImage:[UIImage imageNamed:@"详情-定位符号.png"] forState:UIControlStateNormal];
        [locationBtn addTarget:self action:@selector(goToMapView) forControlEvents:UIControlEventTouchUpInside];
        locationBtn.frame=CGRectMake(ScreenWidth-40, address.frame.origin.x-10.0, 28.0, 45.0);
        [cell.contentView addSubview:locationBtn];
        
        if (self.zhDetailArray.count>0) {
            communityName.text=[NSString stringWithFormat:@"小区: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"com"]];
            address.text=[NSString stringWithFormat:@"地址: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"address"]];
        }else{
            communityName.text=[NSString stringWithFormat:@"小区: %@",self.titleNameStr];
            address.text=@"地址: 暂无";
        }
    }else if (indexPath.row==3){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"config"]!=[NSNull null]) {
            cell.textLabel.text=[NSString stringWithFormat:@"房间配置: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"config"]];
        }else{
          cell.textLabel.text=@"房间配置: 暂无";
        }
    }else if (indexPath.row==4){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"desc"]!=[NSNull null]) {
            cell.textLabel.text=[NSString stringWithFormat:@"详细描述: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"desc"]];
        }else{
           cell.textLabel.text=@"详细描述: 暂无";
        }
    }else if (indexPath.row==5){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"business"]!=[NSNull null]) {
            cell.textLabel.text=[NSString stringWithFormat:@"商业百货: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"business"]];
        }else{
            cell.textLabel.text=@"商业百货: 暂无";
        }
    }else if (indexPath.row==6){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"environmental"]!=[NSNull null]) {
            cell.textLabel.text=[NSString stringWithFormat:@"周边环境: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"environmental"]];
        }else{
            cell.textLabel.text=@"周边环境: 暂无";
        }
    }else if (indexPath.row==7){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"entertainment"]!=[NSNull null]) {
            cell.textLabel.text=[NSString stringWithFormat:@"休闲娱乐: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"entertainment"]];
        }else{
            cell.textLabel.text=@"休闲娱乐: 暂无";
        }
    }else if (indexPath.row==8){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"education"]!=[NSNull null]) {
            cell.textLabel.text=[NSString stringWithFormat:@"学校教育: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"education"]];
        }else{
            cell.textLabel.text=@"学校教育: 暂无";
        }
    }else if (indexPath.row==9){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"facility"]!=[NSNull null]) {
            cell.textLabel.text=[NSString stringWithFormat:@"交通状况 : %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"facility"]];
        }else{
            cell.textLabel.text=@"交通状况 : 暂无";
        }
    }else if (indexPath.row==10){
        UIImageView *brokerView=[[UIImageView alloc] initWithFrame:CGRectMake(10.0, 15.0, 85*2/3, 112*2/3)];
        brokerView.backgroundColor=[UIColor blueColor];
        [cell.contentView addSubview:brokerView];
        
        UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(80, 20.0, cell.frame.size.width, 20.0)];
        name.font=font;
        name.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:name];
        
        UILabel *teleNumber=[[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x, name.frame.origin.y+name.frame.size.height+20.0, name.frame.size.width/2.0+10.0, 20.0)];
        teleNumber.font=font;
        teleNumber.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:teleNumber];
        
        UIButton *callBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        callBtn.frame=CGRectMake(self.view.bounds.size.width-80.0, 22.0, 60.0, 60.0);
        [callBtn addTarget:self action:@selector(callTelePhoen) forControlEvents:UIControlEventTouchUpInside];
        [callBtn setImage:[UIImage imageNamed:@"拨打未点击.png"] forState:UIControlStateNormal];
        [callBtn setImage:[UIImage imageNamed:@"拨打点击.png"] forState:UIControlStateHighlighted];
        [cell.contentView addSubview:callBtn];
        
        name.text=@"姓名: 暂无";
        teleNumber.text=@"电话: 暂无";
        if (self.zhDetailArray.count>0) {
            if ([[self.zhDetailArray objectAtIndex:0] objectForKey:@"mob"] !=[NSNull null]) {
                teleNumber.text=[NSString stringWithFormat:@"电话: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"mob"]];
            }
            if ([[self.zhDetailArray objectAtIndex:0] objectForKey:@"name"] !=[NSNull null]){
                name.text=[NSString stringWithFormat:@"姓名: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"name"]];
            }
            NSString *stringImagePath =[NSString stringWithFormat:@"%@%@",PictureAddress,[[self.zhDetailArray objectAtIndex:0] objectForKey:@"iconurl"]];
            NSLog(@"imagePath:%@",stringImagePath);
            NSString *imagePath = [stringImagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSLog(@"imagePath:%@",imagePath);
            
            [brokerView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"listLoad.png"]];
        }
    }
    return cell;
}
-(void)goToMapView{
    NSLog(@"定位到具体地址");
    if (self.zhDetailArray.count>0) {
        DetailInfoMapViewController *detailMapVC=[[DetailInfoMapViewController alloc] init];
        detailMapVC.lat=[[self.zhDetailArray objectAtIndex:0] objectForKey:@"lat"];
        detailMapVC.lng=[[self.zhDetailArray objectAtIndex:0] objectForKey:@"lng"];
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
    if (self.zhDetailArray.count>0) {
        if ([[self.zhDetailArray objectAtIndex:0] objectForKey:@"mob"] !=[NSNull null]) {
            NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"mob"]];
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
    if (indexPath.row==1||indexPath.row==10){
        return 105.0;
    }else if (indexPath.row==2){
        return 55.0;
    }else if (indexPath.row==3){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"config"]!=[NSNull null]) {
            return [self getLabelHeight:[NSString stringWithFormat:@"房间配置: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"config"]]];
        }else{
            return 40.0;
        }
    }else if (indexPath.row==4){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"desc"]!=[NSNull null]) {
            return [self getLabelHeight:[NSString stringWithFormat:@"详细描述: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"desc"]]];
        }else{
            return 40.0;
        }
    }else if (indexPath.row==5){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"business"]!=[NSNull null]) {
            return [self getLabelHeight:[NSString stringWithFormat:@"商业百货: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"business"]]];
        }else{
            return 40.0;
        }
    }else if (indexPath.row==6){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"environmental"]!=[NSNull null]) {
            return [self getLabelHeight:[NSString stringWithFormat:@"周边环境: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"environmental"]]];
        }else{
            return 40.0;
        }
    }else if (indexPath.row==7){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"entertainment"]!=[NSNull null]) {
            return [self getLabelHeight:[NSString stringWithFormat:@"休闲娱乐: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"entertainment"]]];
        }else{
            return 40.0;
        }
    }else if (indexPath.row==8){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"education"]!=[NSNull null]) {
            return [self getLabelHeight:[NSString stringWithFormat:@"学校教育: %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"education"]]];
        }else{
            return 40.0;
        }
    }else if (indexPath.row==9){
        if (self.zhDetailArray.count>0&&[[self.zhDetailArray objectAtIndex:0] objectForKey:@"facility"]!=[NSNull null]) {
            return [self getLabelHeight:[NSString stringWithFormat:@"交通状况 : %@",[[self.zhDetailArray objectAtIndex:0] objectForKey:@"facility"]]];
        }else{
            return 40.0;
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
