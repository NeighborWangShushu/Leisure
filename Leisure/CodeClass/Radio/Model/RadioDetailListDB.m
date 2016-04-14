//
//  RadioDetailListDB.m
//  Leisure
//
//  Created by 王斌 on 16/4/13.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "RadioDetailListDB.h"

@implementation RadioDetailListDB

// 重写初始化方法
- (instancetype)init {
    if (self = [super init]) {
        _dataBase = [DBManager defaultDBManager:SQLITENAME].dataBase;
    }
    return self;
}

// 创建数据表
- (void)createDataTable {
    // 查询数据表中元素的个数
    FMResultSet *set = [_dataBase executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@' ", RADIODETAILTABLE]];
    [set next]; // 结果集中就一条记录且一个字段无列名
    NSInteger count = [set intForColumnIndex:0]; // 获取整形字段的信息
    if (count) {
        // 不为0表已经存在
        NSLog(@"数据表已经存在");
    } else {
        // 表不存在创建新的表
        NSString *sql = [NSString stringWithFormat:@"create table IF NOT EXISTS %@(radioID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, coverimg TEXT, isnew INTEGER, musicUrl TEXT, title TEXT, musicVisit TEXT, savePath TEXT)", RADIODETAILTABLE];
        BOOL result = [_dataBase executeUpdate:sql];
        if (result) {
            NSLog(@"数据表创建成功");
        } else {
            NSLog(@"数据表创建失败");
        }
    }
}

// 插入一条数据
- (void)saveDataWithModel:(RadioDetailListModel *)model savepath:(NSString *)savepath {
    // 创建插入语句
    NSMutableString *insert = [NSMutableString stringWithFormat:@"insert into %@(coverimg, isnew, musicUrl, title, musicVisit, savePath) values(?, ?, ?, ?, ?, ?)",RADIODETAILTABLE];
    // 创建插入内容
    NSMutableArray *arguments = [NSMutableArray array];
    
    // 判断model内是否存在数据
    if (model.coverimg) {
        [arguments addObject:model.coverimg];
    }
    [arguments addObject:[NSString stringWithFormat:@"%@", model.isnew]];
    [arguments addObject:model.musicUrl];
    [arguments addObject:model.title];
    [arguments addObject:model.musicVisit];
    [arguments addObject:savepath];
    
    // 执行sql
    [self.dataBase executeUpdate:insert withArgumentsInArray:arguments];
}

@end
