//
//  Employee+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by 牛元鹏 on 15/11/17.
//  Copyright © 2015年 牛元鹏. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Employee.h"

NS_ASSUME_NONNULL_BEGIN

@interface Employee (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSDate *birthday;

@end

NS_ASSUME_NONNULL_END
