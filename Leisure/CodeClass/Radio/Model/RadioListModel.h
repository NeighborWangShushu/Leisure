//
//  RadioListModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/30.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"
#import "RadioUserInfoModel.h"

@interface RadioListModel : BaseModel

@property (nonatomic, strong) NSNumber *count; // 收听次数
@property (nonatomic, copy) NSString *coverimg; // 图片地址
@property (nonatomic, copy) NSString *desc; // 说明
@property (nonatomic, copy) NSString *radioid; // 电台id
@property (nonatomic, copy) NSString *title; // 标题

@property (nonatomic, strong) RadioUserInfoModel *userInfo; // 用户信息

@end
