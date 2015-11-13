//
//  DetailInfoMapViewController.h
//  YKHouse
//
//  Created by wjl on 14-6-29.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface DetailInfoMapViewController : UIViewController<BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    NSString *_lat;
    NSString *_lng;
    NSString *_houseTitle;
    
}
@property(nonatomic,strong)NSString *lat;
@property(nonatomic,strong)NSString *lng;
@property(nonatomic,strong)NSString *houseTitle;
@end
