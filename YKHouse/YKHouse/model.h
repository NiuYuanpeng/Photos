//
//  model.h
//  YKHouse
//
//  Created by wjl on 14-6-20.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface model : NSObject

@end

@interface cityArea : NSObject
{
    int _commandcode;
    NSString *_cityName;
}
@property(assign)int commandcode;
@property(nonatomic,strong)NSString *cityName;
@end


@interface esHouseList : NSObject
{
    int _es_commandcode;
    NSString *_es_cityName;
    int _es_page;//分页 （将要请求的页码）每页返回10条数据
    double _es_lat;//经度
    double _es_lng;//纬度
    NSString *_es_area;//区域
    NSString *_es_businesscCircle;//商圈、具体街道
    NSString *_es_price;//价格 不限参数为空字符串如：30-40
    int _es_rType; //房型 0.不限1.一室 2.二室 3.三室 4.四室以上
    NSString *_es_MJ;//面积 （不限参数为空字符串如：50-70）
    NSString *_es_age;//房龄 （不限参数为空字符串如：0-2、2-5）
    int _es_ztype;//类型 0.不限1.公寓2.普通住宅 3.别墅 4.其它
    int _es_desc;//排序 0.默认排序 1.面积从大到小 2.面积从小到大 3.总价从低到高 4.总价从高到低）
}
@property(assign)int es_commandcode;
@property(nonatomic,strong)NSString *es_cityName;
@property(assign)int es_page;
@property(assign)double es_lat;
@property(assign)double es_lng;
@property(nonatomic,strong)NSString *es_area;
@property(nonatomic,strong)NSString *es_businesscCircle;
@property(nonatomic,strong)NSString *es_price;
@property(assign)int es_rType;
@property(nonatomic,strong)NSString *es_MJ;
@property(nonatomic,strong)NSString *es_age;
@property(assign)int es_ztype;
@property(assign)int es_desc;
@end

@interface esHouseDetail : NSObject
{
    int _esd_commandcode;
    NSString *_esd_nid;//房源id
    NSString *_esd_tel;
}
@property(assign)int esd_commandcode;
@property(nonatomic,strong)NSString *esd_nid;
@property(nonatomic,strong)NSString *esd_tel;
@end

@interface login : NSObject
{
    int _login_commandcode;
    NSString *_login_username;//手机号码
    NSString *_login_password;//密码
}
@property(assign)int login_commandcode;
@property(nonatomic,strong)NSString *login_username;//手机号码
@property(nonatomic,strong)NSString *login_password;//密码
@end

@interface registe : NSObject
{
    int _register_commandcode;
    NSString *_register_username;//手机号码
    NSString *_register_password;//密码
    NSString *_register_checkCode;
}
@property(assign)int register_commandcode;
@property(nonatomic,strong)NSString *register_username;//手机号码
@property(nonatomic,strong)NSString *register_password;//密码
@property(nonatomic,strong)NSString *register_checkCode;//短信验证码
@end

@interface checkCode : NSObject
{
    int _checkCode_commandcode;
    int _checkCode_code;//请求类别 1 用户注册 , 2 取回密码
    NSString *_checkCode_username;
}
@property(assign)int checkCode_commandcode;
@property(assign)int checkCode_code;
@property(nonatomic,strong)NSString *checkCode_username;
@end

@interface changePassword : NSObject
{
    int _changePW_commandcode;
    NSString *_changePW_username;
    NSString *_changePW_password;
    NSString *_changePW_newpassword;
}
@property(assign)int changePW_commandcode;
@property(nonatomic,strong)NSString *changePW_username;
@property(nonatomic,strong)NSString *changePW_password;
@property(nonatomic,strong)NSString *changePW_newpassword;
@end

@interface logout : NSObject
{
    int _logout_commandcode;
    NSString *_logout_username;
}
@property(assign)int logout_commandcode;
@property(nonatomic,strong)NSString *logout_username;

@end
@interface esHouseSearch : NSObject
{
    int _eshSearch_commandcode;
    NSString *_eshSearch_cityname;//城市
    NSString *_eshSearch_keyword;//地址或者小区名称
}
@property(assign)int eshSearch_commandcode;
@property(nonatomic,strong)NSString *eshSearch_cityname;
@property(nonatomic,strong)NSString *eshSearch_keyword;
@end

//搜索具体二手房小区的房源列表
@interface esHouseSearchAreaList : NSObject
{
    int _eshsArea_commandcode;
    int _eshsArea_page;
    NSString *_eshsArea_xid;
}
@property(assign)int eshsArea_commandcode;
@property(assign)int eshsArea_page;
@property(nonatomic,strong)NSString *eshsArea_xid;
@end


//租房list
@interface zHouseList : NSObject
{
    int _z_commandcode;
    NSString *_z_cityName;
    int _z_page;//分页 （将要请求的页码）每页返回10条数据
    double _z_lat;//经度
    double _z_lng;//纬度
    NSString *_z_area;//区域
    NSString *_z_businesscCircle;//商圈、具体街道
    NSString *_z_price;//价格 不限参数为空字符串如：0-500、500-800
    int _z_rType; //房型 0.不限1.一室 2.二室 3.三室 4.四室以上
    int _z_person;//类型 0.不限1.经纪人 2.个人
    int _z_ztype;//类型 0.不限1.公寓2.普通住宅 3.别墅 4.其它
    int _z_desc;//排序：0.默认排序1.租金从低到高2.租金从高到低
}
@property(assign)int z_commandcode;
@property(nonatomic,strong)NSString *z_cityName;
@property(assign)int z_page;
@property(assign)double z_lat;
@property(assign)double z_lng;
@property(nonatomic,strong)NSString *z_area;
@property(nonatomic,strong)NSString *z_businesscCircle;
@property(nonatomic,strong)NSString *z_price;
@property(assign)int z_rType;
@property(assign)int z_person;
@property(assign)int z_ztype;
@property(assign)int z_desc;
@end
//租房详情
@interface zHouseDetail : NSObject
{
    int _zd_commandcode;
    NSString *_zd_nid;//房源id
    NSString *_tel;
}
@property(assign)int zd_commandcode;
@property(nonatomic,strong)NSString *zd_nid;
@property(nonatomic,strong)NSString *tel;
@end

//搜索租房小区列表
@interface zHouseSearch : NSObject
{
    int _zhSearch_commandcode;
    NSString *_zhSearch_cityname;//城市
    NSString *_zhSearch_keyword;//地址或者小区名称
}
@property(assign)int zhSearch_commandcode;
@property(nonatomic,strong)NSString *zhSearch_cityname;
@property(nonatomic,strong)NSString *zhSearch_keyword;
@end

//搜索具体租房小区的房源列表
@interface zHouseSearchAreaList : NSObject
{
    int _zhsArea_commandcode;
    int _zhsArea_page;
    NSString *_zhsArea_xid;
}
@property(assign)int zhsArea_commandcode;
@property(assign)int zhsArea_page;
@property(nonatomic,strong)NSString *zhsArea_xid;
@end

//二手房地图房源+数量
@interface esMapHouseSource : NSObject
{
    int _es_commandcode;
    double _es_minLat;
    double _es_maxLat;
    double _es_minLng;
    double _es_maxLng;
    float _es_zoomLevel;
    NSString *_es_cityName;
}
@property(assign)int es_commandcode;
@property(assign)double es_minLat;
@property(assign)double es_maxLat;
@property(assign)double es_minLng;
@property(assign)double es_maxLng;
@property(assign)float es_zoomLevel;
@property(nonatomic,strong)NSString *es_cityName;
@end

//收藏
@interface saveHouseInfo : NSObject
{
    int _saveh_commandcode;
    NSString *_saveh_username;//城市
    NSString *_saveh_nid;//地址或者小区名称
    NSString *_housetype;
}
@property(assign)int saveh_commandcode;
@property(nonatomic,strong)NSString *saveh_username;
@property(nonatomic,strong)NSString *saveh_nid;
@property(nonatomic,strong)NSString *housetype;
@end

//收藏数据库model
@interface saveSqlHouseInfo : NSObject
{
    NSString *_nid;//房源id
    int _flag;//收藏    二手房（102）、租房标记（101）、新房（103）、   浏览历史 租房（104）、二手房（105）、新房（106）
    NSString *_houseName;//房源名称
    NSString *_houseTitle;//房源标题
    NSString *_price;//价格
    NSString *_hStyle;//户型
    NSString *_sampleAddress;//地址简写
    NSString *_houseArea;//房源面积
    NSString *_saveDate;//收藏日期
    NSString *_rentStyle;//出租方式
    NSString *_iconurl;
}
@property(nonatomic,strong)NSString *nid;
@property(assign)int flag;
@property(nonatomic,strong)NSString *houseName;
@property(nonatomic,strong)NSString *houseTitle;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *hStyle;
@property(nonatomic,strong)NSString *sampleAddress;
@property(nonatomic,strong)NSString *houseArea;
@property(nonatomic,strong)NSString *saveDate;
@property(nonatomic,strong)NSString *rentStyle;
@property(nonatomic,strong)NSString *iconurl;
@end

@interface selectCommunity : NSObject
{
    NSString *_cityName;
    NSString *_searchtext;
}
@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,strong)NSString *searchtext;
@end

@interface addHouseSource : NSObject
{
    NSString *_userName;
    NSString *_rentSell;
    NSString *_cid;
    NSString *_houseType;
    NSString *_area;
    NSString *_price;
    NSString *_tel;
    NSString *_remark;
    NSString *_community;
    NSString *_contractName;
}
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *rentSell;
@property(nonatomic,strong)NSString *cid;
@property(nonatomic,strong)NSString *houseType;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *tel;
@property(nonatomic,strong)NSString *remark;
@property(nonatomic,strong)NSString *community;
@property(nonatomic,strong)NSString *contractName;
@end

@interface changeDelegateState : NSObject
{
    NSString *_userName;
    NSString *_nid;
    NSString *_state;
}
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *nid;
@property(nonatomic,strong)NSString *state;
@end

@interface editHouseSource : NSObject
{
    NSString *_userName;
    NSString *_nid;
    NSString *_houseType;
    NSString *_area;
    NSString *_price;
    NSString *_remark;

}
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *nid;
@property(nonatomic,strong)NSString *houseType;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *remark;
@end

//搜索控件控制条件
@interface XYSiftConditionIndex : NSObject{
    NSInteger _willSelectLeftIndex;
    NSInteger _didSelectLeftIndex;
    NSInteger _didSelectRightIndex;
}
@property(nonatomic,readwrite)NSInteger willSelectLeftIndex;
@property(nonatomic,readwrite)NSInteger didSelectLeftIndex;
@property(nonatomic,readwrite)NSInteger didSelectRightIndex;
@end