//
//  YKSql.h
//  YKHouse
//
//  Created by wjl on 14-6-30.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

#define fileName    @"data.sqlite"
@interface YKSql : NSObject
{
    sqlite3 *database;
}
+(instancetype)shareMysql;
-(NSString *)loadPath;
-(BOOL)openDatabase;
-(void)closeDatabase;
-(void)createTable:(NSString *)sql;
-(void)insert:(NSString *)sql;
-(void)deleteData:(NSString *)sql;
-(void)update:(NSString *)sql;
-(NSMutableArray *)show:(NSString *)sql;
-(BOOL)isExistFromSaveHouseInfo:(NSString *)hsid flag:(int)flag;
-(BOOL)deleteDataFromSaveHouseInfoWithNid:(NSString *)hsid flag:(int)flag;
@end
