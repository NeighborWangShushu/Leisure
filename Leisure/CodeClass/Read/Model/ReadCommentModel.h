//
//  ReadCommentModel.h
//  Leisure
//
//  Created by 王斌 on 16/4/9.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"
#import "ReadUserInfoModel.h"

@interface ReadCommentModel : BaseModel

@property (nonatomic, copy) NSString *addtime_f;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSNumber *contentid;
@property (nonatomic, strong) NSNumber *isdel;

@property (nonatomic, strong) ReadUserInfoModel *userinfo;

@end
