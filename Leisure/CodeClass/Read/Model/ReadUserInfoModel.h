//
//  ReadUserInfoModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"

@interface ReadUserInfoModel : BaseModel

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *uname;

@end
