//
//  YKSql.m
//  YKHouse
//
//  Created by wjl on 14-6-30.
//  Copyright (c) 2014年 wjl. All rights reserved.
//

#import "YKSql.h"

@implementation YKSql
static YKSql *mydata;
+(instancetype)shareMysql{
    if (mydata==nil) {
        mydata=[[YKSql alloc] init];
    }
    return mydata;
}
-(NSString *)loadPath{
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *thePath=[paths objectAtIndex:0];
	NSString *path2=[thePath stringByAppendingPathComponent:fileName];
	return path2;
}
-(BOOL)openDatabase{
	if(sqlite3_open([[self loadPath] UTF8String], &database)!=SQLITE_OK){
		sqlite3_close(database);
        NSLog(@"can't open database");
		return NO;
	}
    NSLog(@"database opened successful !!!");
	return YES;
}
-(void)closeDatabase{
	sqlite3_close(database);
}
//创建表格
-(void)createTable:(NSString *)sql{
    [self openDatabase];
	//NSLog(@"%@",sql);
	char *errorsaveSqlModelsage=nil;
	if(sqlite3_exec(database, [sql UTF8String], nil, nil, &errorsaveSqlModelsage)!=SQLITE_OK){
		sqlite3_close(database);
		NSAssert1(0,@"Error:%s",errorsaveSqlModelsage);
	}
}
//增1
-(void)insert:(NSString *)sql{
	[self openDatabase];
	char *errorsaveSqlModelsage=nil;
	NSLog(@"%@",sql);
	if (sqlite3_exec(database, [sql UTF8String], nil, nil, &errorsaveSqlModelsage)!=SQLITE_OK) {
		sqlite3_close(database);
		NSAssert1(0,@"Error:%s",errorsaveSqlModelsage);
	}
	[self closeDatabase];
}
//删
-(void)deleteData:(NSString *)sql{
    NSLog(@"%@",sql);
    [self openDatabase];
	char *errorsaveSqlModelsage;
	if (sqlite3_exec(database, [sql UTF8String], nil, nil, &errorsaveSqlModelsage)!=SQLITE_OK) {
		sqlite3_close(database);
		NSAssert1(0,@"Error:%s",errorsaveSqlModelsage);
	}
	NSLog(@"delete successful");
    [self closeDatabase];
}
//改
-(void)update:(NSString *)sql{
    [self openDatabase];
	char *errorsaveSqlModelsage;
	if (sqlite3_exec(database, [sql UTF8String], nil, nil, &errorsaveSqlModelsage)!=SQLITE_OK) {
		sqlite3_close(database);
		NSAssert1(0,@"Error:%s",errorsaveSqlModelsage);
	}
	[self closeDatabase];
	NSLog(@"update successful");
}
//查saveSqlModelsage
-(NSMutableArray *)show:(NSString *)sql{
    [self openDatabase];
	sqlite3_stmt *stmt;
    //NSLog(@"%@",sql);
	NSMutableArray *arr=[[NSMutableArray alloc] init];
	if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
		while (sqlite3_step(stmt)==SQLITE_ROW) {
            //nid,flag,houseName,houseArea,price,rentStyle,hStyle,sampleAddress,saveDate
            saveSqlHouseInfo *saveSqlModel=[[saveSqlHouseInfo alloc] init];
            char *_nid=(char *)sqlite3_column_text(stmt,0);
            saveSqlModel.nid=[NSString stringWithUTF8String:_nid];
            saveSqlModel.flag=sqlite3_column_int(stmt,1);
            char *_houseName=(char *)sqlite3_column_text(stmt,2);
            saveSqlModel.houseName=[NSString stringWithUTF8String:_houseName];
            char *_houseTitle=(char *)sqlite3_column_text(stmt,3);
            saveSqlModel.houseTitle=[NSString stringWithUTF8String:_houseTitle];
            char *_houseArea=(char *)sqlite3_column_text(stmt,4);
            saveSqlModel.houseArea=[NSString stringWithUTF8String:_houseArea];
            char *_price=(char *)sqlite3_column_text(stmt,5);
            saveSqlModel.price=[NSString stringWithUTF8String:_price];
            char *_rentStyle=(char *)sqlite3_column_text(stmt,6);
            saveSqlModel.rentStyle=[NSString stringWithUTF8String:_rentStyle];
            char *_hStyle=(char *)sqlite3_column_text(stmt,7);
            saveSqlModel.hStyle=[NSString stringWithUTF8String:_hStyle];
            char *_sampleAddress=(char *)sqlite3_column_text(stmt,8);
            saveSqlModel.sampleAddress=[NSString stringWithUTF8String:_sampleAddress];
            char *_iconurl=(char *)sqlite3_column_text(stmt,9);
            saveSqlModel.iconurl=[NSString stringWithUTF8String:_iconurl];
            char *_saveDate=(char *)sqlite3_column_text(stmt,10);
            saveSqlModel.saveDate=[NSString stringWithUTF8String:_saveDate];
            [arr addObject:saveSqlModel];
		}
	}
	sqlite3_finalize(stmt);
    [self closeDatabase];
	return arr;
}
-(BOOL)deleteDataFromSaveHouseInfoWithNid:(NSString *)hsid flag:(int)flag{
    [self openDatabase];
    NSString *sql=[NSString stringWithFormat:@"delete from saveHouseInfoTable where nid=='%@'and flag==%d;",hsid,flag];
    NSLog(@"%@",sql);
	char *errorsaveSqlModelsage;
	if (sqlite3_exec(database, [sql UTF8String], nil, nil, &errorsaveSqlModelsage)!=SQLITE_OK) {
		sqlite3_close(database);
        NSAssert1(0,@"Error:%s",errorsaveSqlModelsage);
        [self closeDatabase];
        return NO;
        
	}
	NSLog(@"delete successful");
    [self closeDatabase];
    return YES;
}

-(BOOL)isExistFromSaveHouseInfo:(NSString *)hsid flag:(int)flag{
    [self openDatabase];
	sqlite3_stmt *stmt;
    NSString *sql=[NSString stringWithFormat:@"select * from saveHouseInfoTable where nid=='%@' and flag==%d;",hsid,flag];
    NSLog(@"%@",sql);
	if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil)==SQLITE_OK){
		while (sqlite3_step(stmt)==SQLITE_ROW) {
            //nid,flag,houseName,houseArea,price,rentStyle,hStyle,sampleAddress,saveDate
            char *_nid=(char *)sqlite3_column_text(stmt,0);
            NSString *nid=[NSString stringWithUTF8String:_nid];
            if ([hsid isEqualToString:nid]) {
                sqlite3_finalize(stmt);
                [self closeDatabase];
                return YES;
            }
		}
	}
	sqlite3_finalize(stmt);
    [self closeDatabase];
	return NO;
}
@end
