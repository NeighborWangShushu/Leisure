//
//  RadioDetailListDB.h
//  Leisure
//
//  Created by 王斌 on 16/4/13.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
#import "RadioDetailListModel.h"

@interface RadioDetailListDB : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;

// 创建数据表
- (void)createDataTable;

// 保存一条数据
// 将model数据和本地音频路径保存到数据表中
- (void)saveDataWithModel:(RadioDetailListModel *)model savepath:(NSString *)savepath;

@end
