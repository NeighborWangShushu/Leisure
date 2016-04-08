//
//  RadioUserInfoModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/30.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"

@interface RadioUserInfoModel : BaseModel

@property (nonatomic, copy) NSString *icon; // 头像图片地址
@property (nonatomic, copy) NSString *uid; // 用户id
@property (nonatomic, copy) NSString *uname; // 用户昵称

@end
