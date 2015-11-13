//
//  ZHouseMapViewController.h
//  YKHouse
//
//  Created by wjl on 14-6-29.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "AFNetWorkManager.h"
#import "GetMoreLoadView.h"
@interface ZHouseMapViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,AFNetWorkManagerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    CLLocationManager *locationManager;
    NSMutableArray *_esMapSource;//获取数据
    NSMutableArray *_esAnnotations;//加载在mapview上的annotations
    NSMutableArray *_esWillRemoveAnnotations;//要移除的annotations
    esMapHouseSource *esmHouseSource;//model
    int flag;//0 市区 ,1城区,3 楼盘
    BOOL isRequestFollowMapViewMove;//当地图显示的时小区+数量时候 是否伴随地图的移动而重新获取显示数据
    float annotationMoveHeight;//显示具体小区房源的时候mapview需要移动的上下幅度
    
    id <BMKAnnotation> selectedAnnotation;
    
    UIView *backgroundForTableView;
    UITableView *houseSourceTableView;
    UILabel *areaTitleLabel;
    NSMutableArray *_es_mapAreaList;
    int _es_mapxid;//小区id
    int esh_mapAreaNextPage;//是否有下一页 分页
    esHouseSearchAreaList *eshMapAreaList;//model
    GetMoreLoadView *gmView;//tableviewFootView
    UISearchBar *mapSearchBar;
    NSString *_es_searchXid;//搜索小区id
    int _z_searchAreaCount;//搜索小区中小区的房源总数
    
    BOOL formSearchVCGoBack;
    NSString *fromSearcjVCGoBackHouseLat;
    NSString *fromSearcjVCGoBackHouseLng;
    NSString *fromSearcjVCGoBackHouseMid;
}
@property(nonatomic,strong)AFNetWorkManager *zMapAFNetWorkManager;
@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)NSMutableArray *esMapSource;
@property(nonatomic,strong)NSMutableArray *esAnnotations;
@property(nonatomic,strong)NSMutableArray *esWillRemoveAnnotations;
@property(nonatomic,strong)NSMutableArray *es_mapAreaList;
@end
