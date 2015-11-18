//
//  ViewController.m
//  CoreDataDemo
//
//  Created by 牛元鹏 on 14/11/17.
//  Copyright © 2014年 牛元鹏. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>

@interface ViewController ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

#define kScreenW  [UIScreen mainScreen].bounds.size.height


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUpDB];
    [self setUpUI];
        
}
- (void)setUpDB
{
    //
    //    1.创建模型文件 ［相当于一个数据库里的表］
    //    2.添加实体 ［一张表］
    //    3.创建实体类 [相当模型]
    //    4.生成上下文 关联模型文件生成数据库
    /*
     * 关联的时候，如果本地没有数据库文件，Coreadata自己会创建
     */
    
    // 声明上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    _context = context;
    // 上下文关联数据库
    
    //model模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 持久化存储调度器
    // 持久化，把数据保存到一个文件，而不是内存
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 告诉Coredata数据的名字、路径
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *DBNamePath = [docPath stringByAppendingPathComponent:@"company.sqlite"];
    
    NSLog(@"%@",DBNamePath);
    NSError *error;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:DBNamePath] options:nil error:&error];
    context.persistentStoreCoordinator = store;
    
}
- (void)setUpUI
{
    // add
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.backgroundColor = [UIColor lightGrayColor];
    [addBtn setTintColor:[UIColor orangeColor]];
    addBtn.frame = CGRectMake(kScreenW * 0.25, 100, 100, 35);
    [addBtn setTitle:@"添加员工" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addEmployee) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    // seach
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    seachBtn.backgroundColor = [UIColor lightGrayColor];
    [seachBtn setTintColor:[UIColor orangeColor]];
    addBtn.frame = CGRectMake(kScreenW * 0.25, 200, 100, 35);
    [seachBtn setTitle:@"查找员工" forState:UIControlStateNormal];
    [seachBtn addTarget:self action:@selector(seachEmployee) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seachBtn];
    
    // update
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    updateBtn.backgroundColor = [UIColor lightGrayColor];
    [updateBtn setTintColor:[UIColor orangeColor]];
    updateBtn.frame = CGRectMake(kScreenW * 0.25, 300, 100, 35);
    [updateBtn setTitle:@"修改员工" forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateEmployee) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updateBtn];
    
    // delete
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteBtn.backgroundColor = [UIColor lightGrayColor];
    [deleteBtn setTintColor:[UIColor orangeColor]];
    deleteBtn.frame = CGRectMake(kScreenW * 0.25, 400, 100, 35);
    [deleteBtn setTitle:@"删除员工" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteEmployee) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
}

#pragma mark - add
- (void)addEmployee
{
    NSLog(@"%s",__func__);
}
#pragma mark - seach
- (void)seachEmployee
{
    
}
#pragma mark - update
- (void)updateEmployee
{
    
}
#pragma mark - delete
- (void)deleteEmployee
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
