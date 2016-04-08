//
//  ReadInfoModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"
#import "ReadCounterListModel.h"
#import "ReadUserInfoModel.h"

@interface ReadInfoModel : BaseModel

@property (nonatomic, copy) NSString *contentid;

@property (nonatomic, strong) ReadCounterListModel *counterList;
@property (nonatomic, strong) ReadUserInfoModel *userInfo;

@end
