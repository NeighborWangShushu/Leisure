//
//  TopicListModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/30.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"
#import "TopicCounterListModel.h"
#import "TopicUserInfoModel.h"

@interface TopicListModel : BaseModel

@property (nonatomic, copy) NSString *addtime; // 时间戳
@property (nonatomic, copy) NSString *addtime_f; // 发布时间
@property (nonatomic, copy) NSString *content; // 内容
@property (nonatomic, copy) NSString *contentid; // 内容id
@property (nonatomic, copy) NSString *coverimg; // 图像
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, assign) BOOL ishot; // 是否热门
@property (nonatomic, assign) BOOL isrecommend; // 是否推荐

@property (nonatomic, strong) TopicCounterListModel *counter; // 点击相关数据
@property (nonatomic, strong) TopicUserInfoModel *userInfo; // 用户信息


@end
