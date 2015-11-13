//
//  model.m
//  YKHouse
//
//  Created by wjl on 14-6-20.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "model.h"

@implementation model

@end

@implementation cityArea
@synthesize cityName=_cityName;
@synthesize commandcode=_commandcode;
@end

@implementation esHouseList
@synthesize es_cityName=_es_cityName;
@synthesize es_commandcode=_es_commandcode;
@synthesize es_page=_es_page;
@synthesize es_lat=_es_lat;
@synthesize es_lng=_es_lng;
@synthesize es_area=_es_area;
@synthesize es_businesscCircle=_es_businesscCircle;
@synthesize es_price=_es_price;
@synthesize es_age=_es_age;
@synthesize es_MJ=_es_MJ;
@synthesize es_rType=_es_rType;
@synthesize es_ztype=_es_ztype;
@synthesize es_desc=_es_desc;
@end

@implementation esHouseDetail
@synthesize esd_commandcode=_esd_commandcode;
@synthesize esd_nid=_esd_nid;
@synthesize esd_tel=_esd_tel;
@end

@implementation login
@synthesize login_commandcode=_login_commandcode;
@synthesize login_username=_login_username;
@synthesize login_password=_login_password;
@end

@implementation registe
@synthesize register_commandcode=_register_commandcode;
@synthesize register_username=_register_username;
@synthesize register_password=_register_password;
@synthesize register_checkCode=_register_checkCode;
@end

@implementation checkCode
@synthesize checkCode_commandcode=_checkCode_commandcode;
@synthesize checkCode_code=_checkCode_code;
@synthesize checkCode_username=_checkCode_username;
@end

@implementation changePassword
@synthesize changePW_commandcode=_changePW_commandcode;
@synthesize changePW_username=_changePW_username;
@synthesize changePW_password=_changePW_password;
@synthesize changePW_newpassword=_changePW_newpassword;
@end

@implementation logout
@synthesize logout_commandcode=_logout_commandcode;
@synthesize logout_username=_logout_username;
@end

@implementation esHouseSearch
@synthesize eshSearch_commandcode=_eshSearch_commandcode;
@synthesize eshSearch_cityname=_eshSearch_cityname;
@synthesize eshSearch_keyword=_eshSearch_keyword;
@end

@implementation esHouseSearchAreaList
@synthesize eshsArea_commandcode=_eshsArea_commandcode;
@synthesize eshsArea_page=_eshsArea_page;
@synthesize eshsArea_xid=_eshsArea_xid;
@end

@implementation zHouseList
@synthesize z_commandcode=_z_commandcode;
@synthesize z_cityName=_z_cityName;
@synthesize z_page=_z_page;
@synthesize z_lat=_z_lat;
@synthesize z_lng=_z_lng;
@synthesize z_area=_z_area;
@synthesize z_businesscCircle=_z_businesscCircle;
@synthesize z_price=_z_price;
@synthesize z_person=_z_person;
@synthesize z_rType=_z_rType;
@synthesize z_ztype=_z_ztype;
@synthesize z_desc=_z_desc;
@end

@implementation zHouseDetail
@synthesize zd_commandcode=_zd_commandcode;
@synthesize zd_nid=_zd_nid;
@synthesize tel=_tel;
@end

@implementation zHouseSearch
@synthesize zhSearch_commandcode=_zhSearch_commandcode;
@synthesize zhSearch_cityname=_zhSearch_cityname;
@synthesize zhSearch_keyword=_zhSearch_keyword;
@end

@implementation zHouseSearchAreaList
@synthesize zhsArea_commandcode=_zhsArea_commandcode;
@synthesize zhsArea_page=_zhsArea_page;
@synthesize zhsArea_xid=_zhsArea_xid;
@end

@implementation esMapHouseSource
@synthesize es_commandcode=_es_commandcode;
@synthesize es_cityName=_es_cityName;
@synthesize es_maxLat=_es_maxLat;
@synthesize es_maxLng=_es_maxLng;
@synthesize es_minLat=_es_minLat;
@synthesize es_minLng=_es_minLng;
@synthesize es_zoomLevel=_es_zoomLevel;
@end

@implementation saveHouseInfo
@synthesize saveh_commandcode=_saveh_commandcode;
@synthesize saveh_username=_saveh_username;
@synthesize saveh_nid=_saveh_nid;
@synthesize housetype=_housetype;
@end

@implementation saveSqlHouseInfo
@synthesize nid=_nid;
@synthesize flag=_flag;
@synthesize houseName=_houseName;
@synthesize houseTitle=_houseTitle;
@synthesize houseArea=_houseArea;
@synthesize price=_price;
@synthesize rentStyle=_rentStyle;
@synthesize hStyle=_hStyle;
@synthesize sampleAddress=_sampleAddress;
@synthesize saveDate=_saveDate;
@synthesize iconurl=_iconurl;
@end

@implementation selectCommunity
@synthesize cityName = _cityName;
@synthesize searchtext = _searchtext;
@end

@implementation addHouseSource

@synthesize userName = _userName;
@synthesize rentSell = _rentSell;
@synthesize cid = _cid;
@synthesize houseType = _houseType;
@synthesize area = _area;
@synthesize price = _price;
@synthesize tel = _tel;
@synthesize remark = _remark;
@synthesize community = _community;
@synthesize contractName = _contractName;
@end

@implementation changeDelegateState

@synthesize userName = _userName;
@synthesize nid = _nid;
@synthesize state = _state;

@end

@implementation editHouseSource

@synthesize userName = _userName;
@synthesize nid =_nid;
@synthesize houseType = _houseType;
@synthesize area = _area;
@synthesize price = _price;
@synthesize remark = _remark;

@end


@implementation XYSiftConditionIndex

@synthesize willSelectLeftIndex = _willSelectLeftIndex;
@synthesize didSelectLeftIndex = _didSelectLeftIndex;
@synthesize didSelectRightIndex = _didSelectRightIndex;

@end