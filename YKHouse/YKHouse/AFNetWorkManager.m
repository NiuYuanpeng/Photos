//
//  AFNetWorkManager.m
//  YKHouse
//
//  Created by wjl on 14-6-20.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "AFNetWorkManager.h"

@implementation AFNetWorkManager
@synthesize isLoading=_isLoading;
- (id)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}
//获取支持城市列表 100
-(void)getCity{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //NSDictionary *loginParameters =@{@"HEAD_INFO":@"{\"commandcode\":100,\"REQUEST_BODY\":{}}"};
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{}}",CityList_CommandCode];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        //NSLog(@"city_dic:%@",dic);
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:CityList_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:CityList_CommandCode result:nil success:NO];
        }
    }];
}

//获取城市区域以及街道 101
-(void)getAreaAndDetailArea:(cityArea *)area{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"city\":\"%@\"}}",AreaAndStreet_CommandCode,area.cityName];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:AreaAndStreet_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:AreaAndStreet_CommandCode result:nil success:NO];
        }
    }];
}

//二手房列表 102
-(void)getESHouseList:(esHouseList *)esHouse{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    if (esHouse.es_area==NULL) {
        esHouse.es_area=@"";
    }
    if (esHouse.es_businesscCircle==NULL){
        esHouse.es_businesscCircle=@"";
    }
    if (esHouse.es_price==NULL) {
        esHouse.es_price=@"";
    }
    if (esHouse.es_MJ==NULL) {
        esHouse.es_MJ=@"";
    }
    if (esHouse.es_age==NULL) {
        esHouse.es_age=@"";
    }
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"city\":\"%@\",\"p\":%d,\"lat\":%f,\"lng\":%f,\"area\":\"%@\",\"businesscCircle\":\"%@\",\"price\":\"%@\",\"rType\":%d,\"MJ\":\"%@\",\"age \":\"%@\",\"ztype\":%d,\"desc\":%d}}",ESHouseList_CommandCode,esHouse.es_cityName,esHouse.es_page,esHouse.es_lat,esHouse.es_lng,esHouse.es_area,esHouse.es_businesscCircle,esHouse.es_price,esHouse.es_rType,esHouse.es_MJ,esHouse.es_age,esHouse.es_ztype,esHouse.es_desc];

    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        //NSLog(@"%@",responseObject);
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:ESHouseList_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"---------error:%@",error);
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:ESHouseList_CommandCode result:nil success:NO];
        }
    }];
}

//获取二手房详细信息 103
-(void)getESHouseDetail:(esHouseDetail *)esHouseD{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"nid\":\"%@\",\"tel\":\"%@\"}}",ESHouseDetail_CommandCode,esHouseD.esd_nid,esHouseD.esd_tel];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]) {
            [self.delegate didRequestCommandcode:ESHouseDetail_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]) {
          [self.delegate didRequestCommandcode:ESHouseDetail_CommandCode result:nil success:NO];
        }
    }];
}

//租房列表 108
-(void)getZHouseList:(zHouseList *)zHouse{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    if (zHouse.z_area==NULL) {
        zHouse.z_area=@"";
    }
    if (zHouse.z_businesscCircle==NULL){
        zHouse.z_businesscCircle=@"";
    }
    if (zHouse.z_price==NULL) {
        zHouse.z_price=@"";
    }
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"city\":\"%@\",\"p\":%d,\"lat\":%f,\"lng\":%f,\"area\":\"%@\",\"businesscCircle\":\"%@\",\"price\":\"%@\",\"rType \":%d,\"person\":%d,\"ztype\":%d,\"desc\":%d}}",ZHouseList_CommandCode,zHouse.z_cityName,zHouse.z_page,zHouse.z_lat,zHouse.z_lng,zHouse.z_area,zHouse.z_businesscCircle,zHouse.z_price,zHouse.z_rType,zHouse.z_person,zHouse.z_ztype,zHouse.z_desc];
    
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",loginParameters);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        //NSLog(@"%@",responseObject);
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:ZHouseList_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-----------error:%@",error);
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:ZHouseList_CommandCode result:nil success:NO];
        }
    }];
}
//获取租房详细信息 109
-(void)getZHouseDetail:(zHouseDetail *)zHouseD{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"nid\":\"%@\",\"tel\":\"%@\"}}",ZHouseDetail_CommandCode,zHouseD.zd_nid,zHouseD.tel];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:ZHouseDetail_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:ZHouseDetail_CommandCode result:nil success:NO];
        }
    }];
}

//注册 110
-(void)toRegister:(registe *)re{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"username\":\"%@\",\"code\":\"%@\",\"password\":\"%@\"}}",Register_CommandCode,re.register_username,re.register_checkCode,re.register_password];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:Register_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:Register_CommandCode result:nil success:NO];
        }
    }];
}
//登录 111
-(void)toLogin:(login *)lo{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"username\":\"%@\",\"password\":\"%@\"}}",Login_CommandCode,lo.login_username,lo.login_password];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",loginParameters);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:Login_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
           [self.delegate didRequestCommandcode:Login_CommandCode result:nil success:NO];
        }
    }];
}
//二手房搜索小区 112
-(void)getESHouseSearchArea:(esHouseSearch *)eshSearch{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"keyword\":\"%@\",\"city\":\"%@\"}}",ESHouseSearchArea_CommandCode,eshSearch.eshSearch_keyword,eshSearch.eshSearch_cityname];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:ESHouseSearchArea_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:ESHouseSearchArea_CommandCode result:nil success:NO];
        }
    }];
}
//租房搜索小区 114
-(void)getZHouseSearchArea:(zHouseSearch *)zhSearch{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"keyword\":\"%@\",\"city\":\"%@\"}}",zhSearch.zhSearch_commandcode,zhSearch.zhSearch_keyword,zhSearch.zhSearch_cityname];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:zhSearch.zhSearch_commandcode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:zhSearch.zhSearch_commandcode result:nil success:NO];
        }
    }];
}

//根据二手小区id搜索二手小区房源 113
-(void)getESHouseSearchAreaList:(esHouseSearchAreaList *)eshsAreaList{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"xid\":\"%@\",\"p\":%d}}",eshsAreaList.eshsArea_commandcode,eshsAreaList.eshsArea_xid,eshsAreaList.eshsArea_page];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        //NSLog(@"%@",responseObject);
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:eshsAreaList.eshsArea_commandcode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:eshsAreaList.eshsArea_commandcode result:nil success:NO];
        }
    }];
}



//根据租房小区id搜索租房小区房源 115 119 123
-(void)getZHouseSearchAreaList:(zHouseSearchAreaList *)zhsAreaList{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"xid\":\"%@\",\"p\":%d}}",zhsAreaList.zhsArea_commandcode,zhsAreaList.zhsArea_xid,zhsAreaList.zhsArea_page];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    
    NSLog(@"%@",parameterString);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:zhsAreaList.zhsArea_commandcode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:zhsAreaList.zhsArea_commandcode result:nil success:NO];
        }
    }];
}
//根据地图房源信息 118 122
-(void)getESMapHouseSource:(esMapHouseSource *)esmHouseSource{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"city\":\"%@\",\"minlat\":%lf,\"maxlat\":%lf,\"minlng\":%lf,\"maxlng\":%lf,\"zoomLevel\":%f}}",esmHouseSource.es_commandcode,esmHouseSource.es_cityName,esmHouseSource.es_minLat,esmHouseSource.es_maxLat,esmHouseSource.es_minLng,esmHouseSource.es_maxLng,esmHouseSource.es_zoomLevel];
    NSLog(@"118、112parameterString：%@",parameterString);
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:esmHouseSource.es_commandcode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:esmHouseSource.es_commandcode result:nil success:NO];
        }
    }];
}

//收藏房源 124
-(void)saveHouseSourceInfo:(saveHouseInfo *)shInfo{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"username\":\"%@\",\"nid\":\"%@\",\"housetype\":\"%@\"}}",shInfo.saveh_commandcode,shInfo.saveh_username,shInfo.saveh_nid,shInfo.housetype];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    
    NSLog(@"%@",parameterString);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:shInfo.saveh_commandcode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:shInfo.saveh_commandcode result:nil success:NO];
        }
    }];
}

//获取短信验证码 125
-(void)getMessageCheckCode:(checkCode *)cCode{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"username\":\"%@\",\"code\":%d}}",cCode.checkCode_commandcode,cCode.checkCode_username,cCode.checkCode_code];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:cCode.checkCode_commandcode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        NSLog(@"error：%@",error);
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:cCode.checkCode_commandcode result:nil success:NO];
        }
    }];
}
//用验证码登录，并修改密码 126
-(void)loginWithCheckCode:(registe *)re{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"username\":\"%@\",\"code\":\"%@\",\"newpassword\":\"%@\"}}",re.register_commandcode,re.register_username,re.register_checkCode,re.register_password];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:re.register_commandcode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:re.register_commandcode result:nil success:NO];
        }
    }];
}

//修改密码 127
-(void)changePassWord:(changePassword *)cpw{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"username\":\"%@\",\"password\":\"%@\",\"newpassword\":\"%@\"}}",cpw.changePW_commandcode,cpw.changePW_username,cpw.changePW_password,cpw.changePW_newpassword];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:cpw.changePW_commandcode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:cpw.changePW_commandcode result:nil success:NO];
        }
    }];
}

//退出登录 128
-(void)logout:(logout *)lo{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"username\":\"%@\"}}",lo.logout_commandcode,lo.logout_username];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:lo.logout_commandcode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:lo.logout_commandcode result:nil success:NO];
        }
    }];
}

//获取 “关于我们” 信息 129
-(void)getAboutUsInfo{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=@"{\"commandcode\":129,\"REQUEST_BODY\":{}}";
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:129 result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
         [self.delegate didRequestCommandcode:129 result:nil success:NO];
        }
    }];
}

//获取 “广告图片” 信息 130
-(void)getADWithScreenH:(float)screenh{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":130,\"REQUEST_BODY\":{\"flag\":\"a\",\"screenh\":\"%f\"}}",screenh];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
          [self.delegate didRequestCommandcode:130 result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:130 result:nil success:NO];
        }
    }];
}

//获取我的房源信息列表 131
-(void)getMyHouseSourceList:(NSString *)username{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"username\":\"%@\"}}",MyHouseSourceList_CommandCode,username];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:MyHouseSourceList_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:MyHouseSourceList_CommandCode result:nil success:NO];
        }
    }];
}

//选择小区 134
-(void)selectCommunity:(selectCommunity *)sCommunity{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"city\":\"%@\",\"searchtext\":\"%@\"}}",SelectCommunity_CommandCode,sCommunity.cityName,sCommunity.searchtext];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:SelectCommunity_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:SelectCommunity_CommandCode result:nil success:NO];
        }
    }];
}

-(void)addHouseSource:(addHouseSource *)addHS{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"username\":\"%@\",\"rentsell\":\"%@\",\"cid\":\"%@\",\"housetype\":\"%@\",\"area\":\"%@\",\"price\":\"%@\",\"tel\":\"%@\",\"contractname\":\"%@\",\"remark\":\"%@\"}}",AddHouseSource_CommandCode,addHS.userName,addHS.rentSell,addHS.cid,addHS.houseType,addHS.area,addHS.price,addHS.tel,addHS.contractName,addHS.remark];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:AddHouseSource_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        NSLog(@"addHouseSource-error:%@",error);
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:AddHouseSource_CommandCode result:nil success:NO];
        }
    }];
}

-(void)editHouseSource:(editHouseSource *)editHS{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"username\":\"%@\",\"nid\":\"%@\",\"housetype\":\"%@\",\"area\":\"%@\",\"price\":\"%@\",\"remark\":\"%@\"}}",EditHouseSource_CommandCode,editHS.userName,editHS.nid,editHS.houseType,editHS.area,editHS.price,editHS.remark];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:EditHouseSource_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        NSLog(@"addHouseSource-error:%@",error);
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:EditHouseSource_CommandCode result:nil success:NO];
        }
    }];
}


-(void)changeDelegateState:(changeDelegateState *)changeDS{
    _isLoading=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *parameterString=[NSString stringWithFormat:@"{\"commandcode\":%d,\"REQUEST_BODY\":{\"username\":\"%@\",\"nid\":\"%@\",\"stats\":\"%@\"}}",ChangeDelegateState_CommandCode,changeDS.userName,changeDS.nid,changeDS.state];
    NSDictionary *loginParameters =@{@"HEAD_INFO":parameterString};
    NSLog(@"%@",parameterString);
    operation=[manager POST:NetWorkAddress parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _isLoading=NO;
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:ChangeDelegateState_CommandCode result:dic success:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading=NO;
        NSLog(@"addHouseSource-error:%@",error);
        if ([self.delegate respondsToSelector:@selector(didRequestCommandcode:result:success:)]){
            [self.delegate didRequestCommandcode:ChangeDelegateState_CommandCode result:nil success:NO];
        }
    }];
}

-(void)cancelCurrentRequest{
    if (_isLoading) {
        //NSLog(@"%@",operation);
        [operation cancel];
    }
}
@end
