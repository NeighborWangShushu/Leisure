//
//  DBManager.m
//  Leisure
//
//  Created by 王斌 on 16/4/12.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

static DBManager *_dbManager = nil;
+ (DBManager *)defaultDBManager:(NSString *)dbName {
    // 互斥锁
    @synchronized(self) {
        if (!_dbManager) {
            _dbManager = [[DBManager alloc] initWithdbName:dbName];
        }
    }
    return _dbManager;
}

- (instancetype)initWithdbName:(NSString *)dbName {
    if (self = [super init]) {
        // 判断数据库名是否存在
        if (!dbName) {
            NSLog(@"创建数据库失败!");
        } else {
            // 获取沙盒路径
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            // 创建数据库路径
            NSString *dbPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",dbName]];
            // exist如果为0表示创建路径成功, 如果为1表示路径已经存在
            BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
            if (!exist) {
                NSLog(@"数据库路径:%@",dbPath);
            } else {
                NSLog(@"数据库路径:%@",dbPath);
            }
            [self openDB:dbPath];
        }
    }
    return self;
}

// 打开数据库
- (void)openDB:(NSString *)dbPath {
    if (!_dataBase) {
        self.dataBase = [FMDatabase databaseWithPath:dbPath];
    }
    if (![_dataBase open]) {
        NSLog(@"不能打开数据库");
    }
}

// 关闭数据库
- (void)closeDB {
    [_dataBase close];
    _dbManager = nil;
}

- (void)dealloc {
    [self closeDB];
}


@end
