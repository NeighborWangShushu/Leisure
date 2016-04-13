//
//  ReadDetailDB.h
//  Leisure
//
//  Created by 王斌 on 16/4/12.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
#import "ReadDetailListModel.h"

@interface ReadDetailDB : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;

// 创建数据表
- (void)createDataTable;

// 插入一条数据
- (void)saveDetailModel:(ReadDetailListModel *)detailModel;

// 删除一条数据
- (void)deleteDetailWithTitle:(NSString *)detailTitle;

// 查询所有数据
- (NSArray *)findWithUserID:(NSString *)userID;

@end
