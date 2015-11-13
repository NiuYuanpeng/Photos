//
//  HouseMapViewController.h
//  YKHouse
//
//  Created by wjl on 14/11/10.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "HouseTableViewForMap.h"
@interface HouseMapViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet BMKMapView *_mapView;
    UISearchBar *mapSearchBar;
    BMKLocationService* _locService;
    UIView *backgroundForTableView;
    
    HouseTableViewForMap *houseTableView;
}

@end
