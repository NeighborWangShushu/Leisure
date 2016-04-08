//
//  TopicCommentListModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/30.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"
#import "TopicUserInfoModel.h"

@interface TopicCommentListModel : BaseModel

@property (nonatomic, copy) NSString *addtime_f; // 评论时间
@property (nonatomic, copy) NSString *content; // 评论内容
@property (nonatomic, copy) NSString *contentid; // 评论的id

@property (nonatomic, strong) TopicUserInfoModel *userInfo; // 用户信息

@end
