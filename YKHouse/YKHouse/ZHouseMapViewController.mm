//
//  ZHouseMapViewController.m
//  YKHouse
//
//  Created by wjl on 14-6-29.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "ZHouseMapViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZHouseDetailInfoViewController.h"
#import "ZHouseTableViewCell.h"
#import "SearchViewController.h"
@interface ZHouseMapViewController ()

@end

@implementation ZHouseMapViewController
@synthesize mapView=_mapView;
@synthesize esMapSource=_esMapSource;
@synthesize esAnnotations=_esAnnotations;
@synthesize esWillRemoveAnnotations=_esWillRemoveAnnotations;
@synthesize es_mapAreaList=_es_mapAreaList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _zMapAFNetWorkManager = [[AFNetWorkManager alloc] init];
        _zMapAFNetWorkManager.delegate = self;
    }
    return self;
}
-(void)showBackGroundForTableView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    backgroundForTableView.frame=CGRectMake(0.0, 100.0, self.view.bounds.size.width, self.view.bounds.size.height-100.0);
    [UIView commitAnimations];
    NSLog(@"%f",backgroundForTableView.frame.origin.x);
    NSLog(@"%f",backgroundForTableView.frame.origin.y);
    NSLog(@"%f",backgroundForTableView.frame.size.height);
    NSLog(@"%f",backgroundForTableView.frame.size.width);
}
-(void)hiddenBackGroundForTableView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    backgroundForTableView.frame=CGRectMake(0.0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-100.0);
    [UIView commitAnimations];
    [self.mapView deselectAnnotation:selectedAnnotation animated:YES];
    [self.es_mapAreaList removeAllObjects];
    [houseSourceTableView reloadData];
    eshMapAreaList.eshsArea_page=1;
    esh_mapAreaNextPage=1;
    houseSourceTableView.tableFooterView=nil;
    formSearchVCGoBack=NO;
    [self.mapView setMapCenterToScreenPt:CGPointMake(self.mapView.bounds.size.width/2.0, self.mapView.bounds.size.height/2.0)];
}

-(void)addBackGroudForTableView{
    backgroundForTableView=[[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-100.0)];
    backgroundForTableView.tag=99999;
    areaTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20.0, 12.0, backgroundForTableView.bounds.size.width-100.0, 20.0)];
    areaTitleLabel.font=[UIFont systemFontOfSize:18.0];
    [backgroundForTableView addSubview:areaTitleLabel];
    UIButton *hiddenBGForTableViewButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [hiddenBGForTableViewButton setBackgroundImage:[UIImage imageNamed:@"叉号.png"] forState:UIControlStateNormal];    [hiddenBGForTableViewButton addTarget:self action:@selector(hiddenBackGroundForTableView) forControlEvents:UIControlEventTouchUpInside];
    hiddenBGForTableViewButton.frame=CGRectMake(backgroundForTableView.bounds.size.width-40.0, 12.0, 20.0, 20.0);
    [backgroundForTableView addSubview:hiddenBGForTableViewButton];
    UIColor *lineColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"底部导航-蓝色条640px-3px.png"]];
    UILabel *secondLine=[[UILabel alloc] initWithFrame:CGRectMake(0.0, hiddenBGForTableViewButton.frame.origin.y+hiddenBGForTableViewButton.bounds.size.height+10.0, backgroundForTableView.bounds.size.width, 1.0)];
    secondLine.backgroundColor=lineColor;
    [backgroundForTableView addSubview:secondLine];
    backgroundForTableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
    
    houseSourceTableView=[[UITableView alloc] initWithFrame:CGRectMake(0.0, secondLine.frame.origin.y+secondLine.bounds.size.height, backgroundForTableView.bounds.size.width, backgroundForTableView.bounds.size.height-secondLine.frame.origin.y-secondLine.bounds.size.height) style:UITableViewStylePlain];
    houseSourceTableView.rowHeight=100.0;
    houseSourceTableView.delegate=self;
    houseSourceTableView.dataSource=self;
    [backgroundForTableView addSubview:houseSourceTableView];
    [self.view addSubview:backgroundForTableView];
    
    gmView=[[GetMoreLoadView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50.0)];
    _es_mapAreaList=[[NSMutableArray alloc] init];
    eshMapAreaList=[[esHouseSearchAreaList alloc] init];
    eshMapAreaList.eshsArea_commandcode=123;
    eshMapAreaList.eshsArea_page=1;
}

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
    BOOL addBGForTV=YES;
    for (id object in self.view.subviews) {
        if ([object isKindOfClass:[UIView class]]) {
            UIView *v=(UIView *)object;
            if (v.tag==99999) {
                [self.view bringSubviewToFront:v];
                addBGForTV=NO;
            }
        }
    }
    if (addBGForTV) {
        [self getHouseSourceNumber];
        [self addBackGroudForTableView];
    }
    
    if (formSearchVCGoBack) {
        [self.mapView setMapCenterToScreenPt:CGPointMake(self.mapView.bounds.size.width/2.0, 60.0)];
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([fromSearcjVCGoBackHouseLat doubleValue], [fromSearcjVCGoBackHouseLng doubleValue]) animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>7.0) {
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, NavigationBarLineY, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.view = _mapView;
    self.mapView.zoomLevel=12.0;
    
    _locService = [[BMKLocationService alloc]init];
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake([[userDefault objectForKey:@"lat"] doubleValue],[[userDefault objectForKey:@"lng"] doubleValue]) animated:NO];
    _esMapSource=[[NSMutableArray alloc] init];
    _esAnnotations=[[NSMutableArray alloc] init];
    _esWillRemoveAnnotations=[[NSMutableArray alloc] init];
    self.mapView.minZoomLevel=9.0;
    isRequestFollowMapViewMove=YES;//伴随着地图视图的移动而重新获取数据
    mapSearchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(20.0, 2.0, self.view.bounds.size.width-40.0, 40)];
    mapSearchBar.barStyle=UIBarStyleDefault;
    mapSearchBar.translucent=YES;
    mapSearchBar.delegate=self;
    mapSearchBar.userInteractionEnabled=NO;
    mapSearchBar.backgroundImage=[UIImage imageNamed:@"搜索底色.png"];
    //mapSearchBar.tintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"顶部导航底色.png"]];
    mapSearchBar.placeholder=@"请输入地址或小区名";
    mapSearchBar.showsCancelButton=NO;
    self.navigationItem.titleView=mapSearchBar;
    formSearchVCGoBack=NO;
    // Do any additional setup after loading the view.
}
//获取房源
-(void)getHouseSourceNumber{
    CLLocationCoordinate2D minMapCoordinate =[self.mapView convertPoint:CGPointMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y) toCoordinateFromView:self.mapView];
    NSLog(@"location:%f,%f",minMapCoordinate.latitude,minMapCoordinate.longitude);
    CLLocationCoordinate2D maxMapCoordinate =[self.mapView convertPoint:CGPointMake(self.mapView.frame.origin.x+self.mapView.frame.size.width, self.mapView.frame.origin.y+self.mapView.frame.size.height) toCoordinateFromView:self.mapView];
    NSLog(@"location:%lf,%lf",maxMapCoordinate.latitude,maxMapCoordinate.longitude);
    esmHouseSource=[[esMapHouseSource alloc] init];
    esmHouseSource.es_commandcode=122;
    esmHouseSource.es_minLat=maxMapCoordinate.latitude;
    esmHouseSource.es_minLng=minMapCoordinate.longitude;
    esmHouseSource.es_maxLat=minMapCoordinate.latitude;
    esmHouseSource.es_maxLng=maxMapCoordinate.longitude;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    esmHouseSource.es_cityName=[defaults objectForKey:@"currentCityName"];
    esmHouseSource.es_zoomLevel=self.mapView.zoomLevel;
    self.mapView.isSelectedAnnotationViewFront=YES;
    if (self.zMapAFNetWorkManager.isLoading) {
        [self.zMapAFNetWorkManager cancelCurrentRequest];
    }
    [self.zMapAFNetWorkManager getESMapHouseSource:esmHouseSource];
}
#pragma AFNetWorkManagerDelegate
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess{
    NSLog(@"%@",resultDic);
    /*
     3-2000km,4-1000km,5-500km,6-200km,7-100km,8-50km,9-25km,10-20km,11-10km,12-5km,13-2km,14-1km,15-500m,16-200m,17-100m,18-50m,19-20m
     */
    if (isSuccess) {
        mapSearchBar.userInteractionEnabled=YES;
        if (code==122) {
            [self.esAnnotations removeAllObjects];
            [self.esMapSource removeAllObjects];
            [self.esMapSource addObjectsFromArray:[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"]];
            if (self.esMapSource.count>0) {
                flag=[[[self.esMapSource objectAtIndex:0] objectForKey:@"flag"] intValue];
                if ([[[self.esMapSource objectAtIndex:0] objectForKey:@"flag"] intValue]<4) {//市+数量
                    for (int i=0; i<self.esMapSource.count; i++) {
                        BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
                        item.coordinate = CLLocationCoordinate2DMake([[[self.esMapSource objectAtIndex:i] objectForKey:@"lat"] doubleValue], [[[self.esMapSource objectAtIndex:i] objectForKey:@"lng"] doubleValue]);//经纬度
                        if (flag==3) {
                            if ([[self.esMapSource objectAtIndex:i] objectForKey:@"mid"]!=[NSNull null]) {
                                item.title = [[self.esMapSource objectAtIndex:i] objectForKey:@"mid"];
                            }
                        }else{
                            item.title = @"未知";
                            if ([[self.esMapSource objectAtIndex:i] objectForKey:@"title"]!=[NSNull null]) {
                                if (![[[self.esMapSource objectAtIndex:i] objectForKey:@"title"]isEqualToString:@""]) {
                                    NSString *titleStr = [[[self.esMapSource objectAtIndex:i] objectForKey:@"title"] stringByReplacingOccurrencesOfString:@" " withString:@""];
                                    item.title = titleStr;
                                }
                            }
                        }
                        item.subtitle=[NSString stringWithFormat:@"%d",[[[self.esMapSource objectAtIndex:i] objectForKey:@"count"] intValue]];//标题
                        [self.esAnnotations addObject:item
                         ];
                    }
                    [self.mapView addAnnotations:self.esAnnotations];
                }
                
            }
        }
        else if (code==123){
            esh_mapAreaNextPage=[[resultDic objectForKey:@"RESPONSE_NEXTPAGE"] intValue];
            if (esh_mapAreaNextPage==1) {
                eshMapAreaList.eshsArea_page++;
                houseSourceTableView.tableFooterView=gmView;
            }else if(esh_mapAreaNextPage==0){
                houseSourceTableView.tableFooterView=nil;
            }
            [self.es_mapAreaList addObjectsFromArray:[[resultDic objectForKey:@"RESPONSE_BODY"] objectForKey:@"list"]];
            NSLog(@"eshAreaList.eshsArea_page:%d",eshMapAreaList.eshsArea_page);
            if (self.es_mapAreaList.count>0) {
                [houseSourceTableView reloadData];
                areaTitleLabel.text=[[self.es_mapAreaList objectAtIndex:0] objectForKey:@"community"];
            }else if (self.es_mapAreaList.count==0){
                areaTitleLabel.text=mapSearchBar.text;
            }
            if (formSearchVCGoBack) {//是从搜索小区界面返回的
                NSLog(@"lat:%lf,%lf",[fromSearcjVCGoBackHouseLat doubleValue],[fromSearcjVCGoBackHouseLng doubleValue]);
                NSString *houseCount=[NSString stringWithFormat:@"%d",_z_searchAreaCount];
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"3",@"flag",houseCount,@"count",fromSearcjVCGoBackHouseLat,@"lat",fromSearcjVCGoBackHouseLng,@"lng",fromSearcjVCGoBackHouseMid,@"mid", nil];
                [self.esAnnotations removeAllObjects];
                [self.esMapSource removeAllObjects];
                [self.esMapSource addObject:dic];
                if (self.esMapSource.count>0) {
                    flag=[[[self.esMapSource objectAtIndex:0] objectForKey:@"flag"] intValue];
                    if ([[[self.esMapSource objectAtIndex:0] objectForKey:@"flag"] intValue]<4) {//市+数量
                        for (int i=0; i<self.esMapSource.count; i++) {
                            BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
                            item.coordinate = CLLocationCoordinate2DMake([[[self.esMapSource objectAtIndex:i] objectForKey:@"lat"] doubleValue], [[[self.esMapSource objectAtIndex:i] objectForKey:@"lng"] doubleValue]);//经纬度
                            if ([[self.esMapSource objectAtIndex:i] objectForKey:@"mid"]!=[NSNull null]) {
                                item.title = [[self.esMapSource objectAtIndex:i] objectForKey:@"mid"];
                            }
                            item.subtitle=[NSString stringWithFormat:@"%d",[[[self.esMapSource objectAtIndex:i] objectForKey:@"count"] intValue]];//标题
                            [self.esAnnotations addObject:item];
                        }
                        [self.mapView addAnnotations:self.esAnnotations];
                    }
                }
            }
        }
    }
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"%f,%f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
    if (flag<3) {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(view.annotation.coordinate.latitude,view.annotation.coordinate.longitude) animated:NO];
        if (self.mapView.zoomLevel<11||self.mapView.zoomLevel==11) {
            self.mapView.zoomLevel=12.0;
        }else if (self.mapView.zoomLevel<14&&self.mapView.zoomLevel>11){
            self.mapView.zoomLevel=16.0;
        }
    }else if (flag==3){
        NSLog(@"显示小区信息%@",view.annotation.subtitle);
        isRequestFollowMapViewMove=NO;
        view.image=[self getAnnotationImage:@"selectedSign.png" subTitle:view.annotation.subtitle];
        CGPoint point=[self.mapView convertCoordinate:view.annotation.coordinate toPointToView:self.mapView];
        CGPoint centerPoint=[self.mapView convertCoordinate:self.mapView.centerCoordinate toPointToView:self.mapView];
        if (point.y>60.0) {
            annotationMoveHeight=point.y-60.0;
            centerPoint.y+=annotationMoveHeight;
        }
        NSLog(@"z:%f,y:%f",centerPoint.x,centerPoint.y);
        CLLocationCoordinate2D centerLocationCoordinate=[self.mapView convertPoint:centerPoint toCoordinateFromView:self.mapView];
        [self.mapView setCenterCoordinate:centerLocationCoordinate animated:YES];
        eshMapAreaList.eshsArea_xid=view.annotation.title;
        if (self.zMapAFNetWorkManager.isLoading) {
            //[self.zMapAFNetWorkManager cancelCurrentRequest];
        }
        [self.zMapAFNetWorkManager getESHouseSearchAreaList:eshMapAreaList];
        [self showBackGroundForTableView];
        areaTitleLabel.text=@"正在加载中...";
    }
    selectedAnnotation=view.annotation;
    /*
     zoomLevel>14.0||zoomLevel==14.0    返回小区+数量
     14.0>zoomLevel>11.0              返回区域+数量
     zoomLevel<11.0||zoomLevel==11.0    返回市+数量
     */
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    if (flag==3){
        view.image=[self getAnnotationImage:@"sign.png" subTitle:view.annotation.subtitle];
        isRequestFollowMapViewMove=YES;
        [self.es_mapAreaList removeAllObjects];
        [houseSourceTableView reloadData];
        eshMapAreaList.eshsArea_page=1;
        esh_mapAreaNextPage=1;
        houseSourceTableView.tableFooterView=nil;
    }
}
//地图区域改变完成后会调用此接口
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"self.mapView.zoomlevel:%f",mapView.zoomLevel);
    NSLog(@"%lf,%f",self.mapView.centerCoordinate.latitude,self.mapView.centerCoordinate.longitude);
    if (formSearchVCGoBack&&self.mapView.zoomLevel<16.0) {
        self.mapView.zoomLevel=16.0;
    }
    if ((isRequestFollowMapViewMove||esmHouseSource.es_zoomLevel!=self.mapView.zoomLevel)&&!formSearchVCGoBack) {
        [self getHouseSourceNumber];
    }
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    NSLog(@"%lf,%f",self.mapView.centerCoordinate.latitude,self.mapView.centerCoordinate.longitude);
    NSLog(@"onClickedMapBlank%f",self.mapView.zoomLevel);
    [self hiddenBackGroundForTableView];
}
-(UIImage *)getAnnotationImage:(NSString *)imageName subTitle:(NSString *)subString{
    UIView *viewForImage=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 70.0, 50.0)];
    UIImageView *imageOnView=[[UIImageView alloc] initWithFrame:viewForImage.frame];
    imageOnView.image=[UIImage imageNamed:imageName];
    [viewForImage addSubview:imageOnView];
    UILabel *subLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 12.0, 70.0, 20.0)];
    subLabel.text=[NSString stringWithFormat:@"%@套",subString];
    subLabel.textAlignment=NSTextAlignmentCenter;
    subLabel.textColor=[UIColor whiteColor];
    subLabel.font=[UIFont boldSystemFontOfSize:24.0];
    subLabel.backgroundColor=[UIColor clearColor];
    [viewForImage addSubview:subLabel];
    return [self getImageFromView:viewForImage];
}
-(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(float)getMaxAnnotationViewLabelWidth:(NSString *)firstString secString:(NSString *)secondString{
    CGSize firstStringSize = [firstString sizeWithFont:[UIFont boldSystemFontOfSize:24.0] constrainedToSize:CGSizeMake(self.view.frame.size.width-40.0, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize secondStringSize = [firstString sizeWithFont:[UIFont boldSystemFontOfSize:24.0] constrainedToSize:CGSizeMake(self.view.frame.size.width-40.0, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    if (firstStringSize.width>30.0||secondStringSize.width>30.0) {
        if (firstStringSize.width>secondStringSize.width) {
            return firstStringSize.width+10.0;
        }else{
            return secondStringSize.width+10.0;
        }
    }
    return 55.0;
}

//自定义map的大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationId"];
        if (annotationView == nil) {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
            annotationView.canShowCallout=NO;
            if (flag<3) {
                float maxWidth=[self getMaxAnnotationViewLabelWidth:annotation.title secString:annotation.subtitle];
                float viewForAnnotation=sqrtf(20.0*20.0+maxWidth/2*maxWidth/2);
                UIView *viewForImage=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 2*viewForAnnotation, 2*viewForAnnotation)];
                viewForImage.backgroundColor=[UIColor colorWithRed:55/255.0 green:173/255.0 blue:253/255.0 alpha:0.8];
                viewForImage.layer.cornerRadius = viewForAnnotation;//(值越大，角就越圆)
                viewForImage.layer.masksToBounds = YES;
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(viewForAnnotation-maxWidth/2, viewForAnnotation-20.0, maxWidth, 20.0)];
                label.text=annotation.title;
                label.textColor=[UIColor whiteColor];
                label.textAlignment=NSTextAlignmentCenter;
                label.font=[UIFont boldSystemFontOfSize:24.0];
                label.backgroundColor=[UIColor clearColor];
                [viewForImage addSubview:label];
                UILabel *subLabel=[[UILabel alloc] initWithFrame:CGRectMake(viewForAnnotation-maxWidth/2, viewForAnnotation, maxWidth, 20.0)];
                subLabel.text=annotation.subtitle;
                subLabel.textColor=[UIColor whiteColor];
                subLabel.textAlignment=NSTextAlignmentCenter;
                subLabel.font=[UIFont boldSystemFontOfSize:24.0];
                subLabel.backgroundColor=[UIColor clearColor];
                [viewForImage addSubview:subLabel];
                annotationView.image=[self getImageFromView:viewForImage];
            }else if (flag==3){
                annotationView.image=[self getAnnotationImage:@"sign.png" subTitle:annotation.subtitle];
            }
            
        }
        return annotationView;
        
    }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
//    [self.mapView removeAnnotations:self.esWillRemoveAnnotations];
//    NSLog(@"%d",self.mapView.annotations.count);
//    NSLog(@"%d",self.esMapSource.count);
//    [self.esWillRemoveAnnotations removeAllObjects];
//    [self.esWillRemoveAnnotations addObjectsFromArray:self.esAnnotations];
    
    [self.mapView removeAnnotations:self.esWillRemoveAnnotations];
    NSLog(@"mapView.annotations：%d",mapView.annotations.count);
    NSLog(@"esAnnotations：%d",self.esAnnotations.count);
    if (mapView.annotations.count == self.esAnnotations.count) {
        [self.esWillRemoveAnnotations removeAllObjects];
        [self.esWillRemoveAnnotations addObjectsFromArray:self.esAnnotations];
    }
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    //[_mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude) animated:NO];
    BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
    item.coordinate = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);//经纬度
    item.title = @"我的位置";    //标题
    //[_mapView addAnnotation:item];
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.es_mapAreaList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    ZHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.iconUrl=[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"iconurl"];
    cell.nameString=[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    cell.addressString=[NSString stringWithFormat:@"%@  %@",[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"community"],[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"simpleadd"]];
    cell.hxString=[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"housetype"];
    cell.money=[[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"price"] integerValue];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==self.es_mapAreaList.count-1&&esh_mapAreaNextPage&&!self.zMapAFNetWorkManager.isLoading){//列表是二手房源列表&&显示最后一行&&当前没有请求在进行&&二手房源有下一页
        //        NSLog(@"%d",indexPath.row);
        if (self.zMapAFNetWorkManager.isLoading) {
            //[self.zMapAFNetWorkManager cancelCurrentRequest];
        }
        self.zMapAFNetWorkManager.delegate=self;
        [self.zMapAFNetWorkManager getESHouseSearchAreaList:eshMapAreaList];
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZHouseDetailInfoViewController *zHouseDetailInfoVC=[[ZHouseDetailInfoViewController alloc] init];
    zHouseDetailInfoVC.titleNameStr=[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"community"];
    zHouseDetailInfoVC.nid=[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"nid"];
    zHouseDetailInfoVC.zcamera=[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"camera"];
    zHouseDetailInfoVC.zcid=[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"cid"];
    zHouseDetailInfoVC.zhouseType=[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"housetype"];
    zHouseDetailInfoVC.zPrice=[[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"price"] intValue];
    zHouseDetailInfoVC.iconurl=[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"iconurl"];
    zHouseDetailInfoVC.zcommunity=[[self.es_mapAreaList objectAtIndex:indexPath.row] objectForKey:@"title"];
    zHouseDetailInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zHouseDetailInfoVC animated:YES];
    
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SearchViewController *searchVC=[SearchViewController shareSearchVC];
    searchVC.hidesBottomBarWhenPushed=YES;
    searchVC.commandcode=114;
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    searchVC.cityname=[userDefault objectForKey:@"currentCityName"];
    [self.navigationController pushViewController:searchVC animated:YES];
    [self hiddenBackGroundForTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeESMapSearBarTitle:) name:@"zMapChangeSearBarTitle" object:nil];
    [searchBar resignFirstResponder];
    return  YES;
}
-(void)changeESMapSearBarTitle:(id)sender{
    NSLog(@"sender:%@",sender);
    mapSearchBar.text=[[sender object] objectForKey:@"title"];
    _es_searchXid=[[sender object] objectForKey:@"xid"];
    _z_searchAreaCount=[[[sender object] objectForKey:@"count"] intValue];
    fromSearcjVCGoBackHouseMid=[[sender object] objectForKey:@"xid"];
    formSearchVCGoBack=YES;
    if ([[sender object] objectForKey:@"lat"]!=[NSNull null]) {
        fromSearcjVCGoBackHouseLat=[[sender object] objectForKey:@"lat"];
        fromSearcjVCGoBackHouseLng=[[sender object] objectForKey:@"lng"];
    }else{
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        fromSearcjVCGoBackHouseLat=[userDefault objectForKey:@"lat"];
        fromSearcjVCGoBackHouseLng=[userDefault objectForKey:@"lng"];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zMapChangeSearBarTitle" object:nil];
    eshMapAreaList.eshsArea_xid=_es_searchXid;
    if (self.zMapAFNetWorkManager.isLoading) {
        //[self.zMapAFNetWorkManager cancelCurrentRequest];
    }
    [self.zMapAFNetWorkManager getESHouseSearchAreaList:eshMapAreaList];
    [self showBackGroundForTableView];
    areaTitleLabel.text=@"正在加载中...";
}
@end
