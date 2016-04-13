//
//  ReadDetailDB.m
//  Leisure
//
//  Created by 王斌 on 16/4/12.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "ReadDetailDB.h"
#import "UserInfoManager.h"

@implementation ReadDetailDB

- (instancetype)init {
    if (self = [super init]) {
        _dataBase = [DBManager defaultDBManager:SQLITENAME].dataBase;
    }
    return self;
}

// 创建数据表
- (void)createDataTable {
    // 查询数据表中元素个数
    FMResultSet *set = [_dataBase executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'", READDETAILTABLE]];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        NSLog(@"数据表已经存在");
    } else {
        // 创建新的数据表
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (readID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, userID text, title text, contentID text, content text, name text, coverimg text)", READDETAILTABLE];
        BOOL res = [_dataBase executeUpdate:sql];
        if (!res) {
            NSLog(@"数据表创建成功");
        } else {
            NSLog(@"数据表创建失败");
        }
    }
}

// 插入一条数据
- (void)saveDetailModel:(ReadDetailListModel *)detailModel {
    // 创建插入语句
    NSMutableString *query = [NSMutableString stringWithFormat:@"INSERT INTO %@ (userID,title,contentid,content, name, coverimg) values (?,?,?,?,?,?)", READDETAILTABLE];
    // 创建插入内容
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:0];
    if (![[UserInfoManager getUserID] isEqualToString:@""]) {
        [arguments addObject:[UserInfoManager getUserID]];
    }
    if (detailModel.title) {
        [arguments addObject:detailModel.title];
    }
    if (detailModel.contentID) {
        [arguments addObject:detailModel.contentID];
    }
    if (detailModel.content) {
        [arguments addObject:detailModel.content];
    }
    if (detailModel.name) {
        [arguments addObject:detailModel.name];
    }
    if (detailModel.coverimg) {
        [arguments addObject:detailModel.coverimg];
    }
    NSLog(@"%@", query);
    NSLog(@"收藏一条数据");
    // 执行语句
    [_dataBase executeUpdate:query withArgumentsInArray:arguments];
}

// 删除一条数据
- (void)deleteDetailWithTitle:(NSString *)detailTitle {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE title = '%@'", READDETAILTABLE, detailTitle];
    NSLog(@"删除成功");
    [_dataBase executeUpdate:query];
}

// 查询所有数据
- (NSArray *)findWithUserID:(NSString *)userID {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userID = '%@'", READDETAILTABLE, userID];
    FMResultSet *res = [_dataBase executeQuery:query];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[res columnCount]];
    while ([res next]) {
        ReadDetailListModel *detailModel = [[ReadDetailListModel alloc] init];
        detailModel.title = [res stringForColumn:@"title"];
        detailModel.contentID = [res stringForColumn:@"contentid"];
        detailModel.content = [res stringForColumn:@"content"];
        detailModel.name = [res stringForColumn:@"name"];
        detailModel.coverimg = [res stringForColumn:@"coverimg"];
        [array addObject:detailModel];
    }
    [res close];
    return array;
}


@end
