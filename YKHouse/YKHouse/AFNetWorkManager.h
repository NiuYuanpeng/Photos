//
//  AFNetWorkManager.h
//  YKHouse
//
//  Created by wjl on 14-6-20.
//  Copyright (c) 2014年 wjl. All rights reserved.
//
@protocol AFNetWorkManagerDelegate <NSObject>
@optional
-(void)didRequestCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess;
-(void)didRequestForSuperVCommandcode:(int)code result:(NSMutableDictionary *)resultDic success:(BOOL)isSuccess;

@end
#import <Foundation/Foundation.h>
#import "model.h"
#import "AFNetworking.h"
@interface AFNetWorkManager : NSObject<AFNetWorkManagerDelegate>
{
    BOOL _isLoading;
    AFHTTPRequestOperation *operation;
}
@property(assign)BOOL isLoading;
@property (nonatomic, assign)  id <AFNetWorkManagerDelegate> delegate;
-(void)cancelCurrentRequest;//取消当前请求
-(void)getCity; //100、获取支持城市
-(void)getAreaAndDetailArea:(cityArea *)area; //101、获取城市区域街道

-(void)getESHouseList:(esHouseList *)esHouse; //102、获取二手房源列表
-(void)getESHouseDetail:(esHouseDetail *)esHouseD;//103、获取二手房源详细信息

-(void)getZHouseList:(zHouseList *)zHouse;//108、获取租房列表
-(void)getZHouseDetail:(zHouseDetail *)zHouseD;//109、获取租房源详细信息

-(void)getESHouseSearchArea:(esHouseSearch *)eshSearch;//112、获取搜索二手房小区列表
-(void)getZHouseSearchArea:(zHouseSearch *)zhSearch;//114、获取搜索租房小区列表

-(void)getESHouseSearchAreaList:(esHouseSearchAreaList *)eshsAreaList;//根据二手小区id搜索二手小区房源 113
-(void)getZHouseSearchAreaList:(zHouseSearchAreaList *)zhsAreaList;//根据出租小区id搜索出租小区房源 115 119 123

-(void)getESMapHouseSource:(esMapHouseSource *)esmHouseSource;//二手、租房地图房源 118 122

-(void)saveHouseSourceInfo:(saveHouseInfo *)shInfo;//收藏房源 124

-(void)toRegister:(registe *)re;//110、注册
-(void)toLogin:(login *)lo;//111、登录
-(void)getMessageCheckCode:(checkCode *)cCode;//获取短信验证码 125
-(void)loginWithCheckCode:(registe *)re;//通过短信验证码登录 126
-(void)changePassWord:(changePassword *)cpw;//修改密码 127
-(void)logout:(logout *)lo;//退出登录 128
-(void)getAboutUsInfo;//获取 “关于我们” 信息 129
-(void)getADWithScreenH:(float)screenh;//获取 “广告图片” 信息

-(void)getMyHouseSourceList:(NSString *)username;//获取我的房源131
-(void)selectCommunity:(selectCommunity *)sCommunity;//选择小区名称134
-(void)addHouseSource:(addHouseSource *)addHS;//添加房源135
-(void)editHouseSource:(editHouseSource *)editHS;//编辑房源133
-(void)changeDelegateState:(changeDelegateState *)changeDS;//更改房源委托状态132
@end
