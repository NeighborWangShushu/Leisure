//
//  DBManager.h
//  Leisure
//
//  Created by 王斌 on 16/4/12.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBManager : NSObject

@property (nonatomic, strong) FMDatabase *dataBase; // 数据库操作对象

// 单例模式创建数据库操作对象
// 传入数据库名称,在方法中创建数据库
+ (DBManager *)defaultDBManager:(NSString *)dbName;

// 自定义初始化方法
- (instancetype)initWithdbName:(NSString *)dbName;

// 关闭数据库
- (void)closeDB;

@end
