//
//  ProductCommentListModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/30.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"
#import "ProductUserInfoModel.h"

@interface ProductCommentListModel : BaseModel

@property (nonatomic, copy) NSString *addtime_f; // 评论的时间
@property (nonatomic, copy) NSString *content; // 评论的内容
@property (nonatomic, copy) NSString *contentid; // 评论的id

@property (nonatomic, strong) ProductUserInfoModel *userInfo; // 评论者的用户信息

@end
