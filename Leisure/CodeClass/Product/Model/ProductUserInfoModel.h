//
//  ProductUserInfoModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/30.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"

@interface ProductUserInfoModel : BaseModel

@property (nonatomic, copy) NSString *icon; // 用户头像
@property (nonatomic, copy) NSString *uid; // 用户的id
@property (nonatomic, copy) NSString *uname; // 用户的名字

@end
